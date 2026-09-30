# Three-stage LLM metadata extraction, validation and thematic classification
# for every row of data_dig_req (issue #5).
# Prerequisites: run 01_initialise.R, 02_data_import.R and
# "06_data_dictionary - data_dig_req.R" (for informant_data_dig_req) first.
# Output: 02_data_output/dig_req_llm_metadata_2.rds (read by 07_report/digital_request_themes.qmd)

source(here::here("01_src", "01_startup", "01_initialise.R"))
source(here::here("01_src", "02_data_import", "02_data_import.R"))
source(here::here("06_data_dictionary", "06_data_dictionary - data_dig_req.R"))
# source(here::here("01_src", "03_wrangle", "ellmer_chat_with_ollama - digital request analysis.R"))

# library(ellmer)
# library(jsonlite)
# library(purrr)
# library(dplyr)

## Config ----------------
model_name <- "gemma4"
max_retries <- 3
base_url <- Sys.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
output_file <- here::here("02_data_output", "dig_req_llm_metadata_2.rds")
n_requests <- 3 # number of requests to process while testing; use Inf for all

# The schema (keys, types, rules) is defined once, in the prompt file
metadata_fields <- c(
  "summary", "key_problem", "requested_outcome", "stakeholders", "business_area",
  "expected_benefits", "dependencies", "risks_or_constraints", "priority_indicators",
  "themes"
)
system_prompt <- paste(
  readLines(here::here("01_src", "03_wrangle", "Prompts", "prompt-digital-request-analysis.md")),
  collapse = "\n"
)
dictionary <- paste(as.character(btw::btw(informant_data_dig_req)), collapse = "\n")

## Helpers ----------------
# Ask a fresh chat for JSON; retry with the error message until required keys are present
ask_json <- function(prompt, required_keys) {
  chat <- chat_ollama(
    system_prompt = system_prompt, base_url = base_url, model = model_name,
    api_args = list(options = list(num_ctx = 32768, temperature = 0)), echo = "none"
  )
  error <- NULL
  for (i in seq_len(max_retries)) {
    p <- if (is.null(error)) prompt else paste0(prompt, "\n\nYour previous reply was invalid (", error, "). Return valid JSON only.")
    out <- tryCatch({
      txt <- chat$chat(p, echo = "none")
      json <- regmatches(txt, regexpr("\\{.*\\}", txt)) # first '{' to last '}'
      if (!length(json)) stop("no JSON object found")
      parsed <- jsonlite::fromJSON(json, simplifyVector = FALSE)
      missing <- setdiff(required_keys, names(parsed))
      if (length(missing)) stop("missing keys: ", paste(missing, collapse = ", "))
      parsed
    }, error = function(e) {
      error <<- conditionMessage(e)
      NULL
    })
    if (!is.null(out)) return(out)
  }
  warning("No valid JSON after ", max_retries, " attempts: ", error)
  NULL
}

to_json <- function(x, ...) jsonlite::toJSON(x, auto_unbox = TRUE, null = "null", ...)

# Stage 1: extract metadata from the source record
extract <- function(row) {
  ask_json(
    paste0("Analyse this digital request record and return the metadata JSON object.\n\n",
           "Data dictionary:\n", dictionary, "\n\nSource record:\n", to_json(row, na = "string")),
    metadata_fields
  )
}

# Stages 2 and 3: check metadata against the record and correct it
review <- function(row, metadata, stage) {
  ask_json(
    paste0("Quality assurance review (stage ", stage, "). Compare the metadata below with the original record ",
           "for omissions, unsupported statements, errors and poor themes, then correct it.\n",
           "Return a JSON object with two keys: \"findings\" (array of strings; empty if none) ",
           "and \"metadata\" (the corrected metadata object, same keys as before).\n\n",
           "Original record:\n", to_json(row, na = "string"), "\n\nMetadata to review:\n", to_json(metadata)),
    c("findings", "metadata")
  )
}

process_row <- function(row) {
  v1 <- extract(row)
  r2 <- if (!is.null(v1)) review(row, v1, 2)
  v2 <- r2$metadata %||% v1
  r3 <- if (!is.null(v2)) review(row, v2, 3)
  v3 <- r3$metadata %||% v2
  tibble::tibble(
    request_row_id = row$request_row_id,
    metadata_v1 = list(v1), findings_v2 = list(unlist(r2$findings)), metadata_v2 = list(v2),
    findings_v3 = list(unlist(r3$findings)), metadata_v3 = list(v3),
    model = model_name, processed_at = Sys.time(), source_record = list(row)
  )
}

## Run (resumable: rows already in output_file are skipped) ----------------
requests <- data_dig_req |>
  mutate(request_row_id = row_number(), .before = 1) |>
  head(n_requests)
done <- if (file.exists(output_file)) readRDS(output_file)
todo <- filter(requests, !request_row_id %in% done$request_row_id)

results <- purrr::map(seq_len(nrow(todo)), \(i) {
  message("Processing request ", i, " of ", nrow(todo))
  process_row(as.list(todo[i, ]))
}) |> bind_rows()

dir.create(dirname(output_file), showWarnings = FALSE, recursive = TRUE)
saveRDS(bind_rows(done, results), output_file) # join to data_dig_req via request_row_id
