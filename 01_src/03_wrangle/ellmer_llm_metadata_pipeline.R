# Three-stage LLM metadata extraction, validation and thematic classification
# for every row of data_dig_req (issue #5).
# Prerequisites: run 01_initialise.R, 02_data_import.R and
# "06_data_dictionary - data_dig_req.R" (for informant_data_dig_req) first.
# Output: 02_data_output/dig_req_llm_metadata_2.rds (read by 07_report/digital_request_themes.qmd)

source(here::here("01_src", "01_startup", "01_initialise.R"))
source(here::here("01_src", "01_startup", "02_data_import.R"))
source(here::here("01_src", "03_wrangle", "06_data_dictionary - data_dig_req.R"))
# source(here::here("01_src", "03_wrangle", "ellmer_chat_with_ollama - digital request analysis.R"))

# library(ellmer)
# library(jsonlite)
# library(purrr)
# library(dplyr)

## Config ----------------
model_name <- "gemma4"
max_json_retries <- 3
base_url <- Sys.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
output_file <- here::here("02_data_output", "dig_req_llm_metadata_2.rds")

metadata_fields <- c(
  "summary", "key_problem", "requested_outcome", "stakeholders", "business_area",
  "expected_benefits", "dependencies", "risks_or_constraints", "priority_indicators",
  "themes"
)

system_prompt <- paste(
  readLines(here::here("01_src", "03_wrangle", "Prompts", "prompt-digital-request-analysis.md")),
  collapse = "\n"
)

json_rules <- paste(
  "Respond with valid JSON only: no markdown, no code fences, no explanatory text.",
  "Use UK English. Do not invent facts; use \"Not stated\" where information is missing.",
  sprintf("The metadata object must have exactly these keys: %s.", paste(metadata_fields, collapse = ", ")),
  "\"themes\" must be a JSON array of one or more short thematic labels (buckets) that help",
  "identify similar or duplicate requests. All other fields are strings, except \"stakeholders\",",
  "\"expected_benefits\", \"dependencies\", \"risks_or_constraints\" and \"priority_indicators\"",
  "which are arrays of strings."
)

## Helpers (DRY) ----------------
new_chat <- function() {
  chat_ollama(
    system_prompt = system_prompt,
    base_url = base_url,
    model = model_name,
    api_args = list(options = list(num_ctx = 32768, temperature = 0)),
    echo = "none"
  )
}

# Strip accidental code fences / surrounding text, then parse
parse_json_strict <- function(txt) {
  txt <- trimws(gsub("^```(json)?|```$", "", trimws(txt)))
  start <- regexpr("\\{", txt)
  end <- max(gregexpr("\\}", txt)[[1]])
  if (start < 0 || end < start) stop("No JSON object found")
  fromJSON(substr(txt, start, end), simplifyVector = FALSE)
}

# Ask the LLM and retry until valid JSON (with required keys) is returned
ask_json <- function(prompt, required_keys) {
  chat <- new_chat()
  last_error <- NULL
  for (i in seq_len(max_json_retries)) {
    p <- if (is.null(last_error)) prompt else
      paste0(prompt, "\n\nYour previous reply was not valid: ", last_error, ". Return valid JSON only.")
    out <- tryCatch({
      parsed <- parse_json_strict(chat$chat(p, echo = "none"))
      missing_keys <- setdiff(required_keys, names(parsed))
      if (length(missing_keys)) stop("missing keys: ", paste(missing_keys, collapse = ", "))
      parsed
    }, error = function(e) {
      last_error <<- conditionMessage(e)
      NULL
    })
    if (!is.null(out)) return(out)
  }
  warning("Failed to obtain valid JSON after ", max_json_retries, " attempts: ", last_error)
  NULL
}

record_json <- function(row) toJSON(as.list(row), auto_unbox = TRUE, null = "null", na = "string")
to_json <- function(x) toJSON(x, auto_unbox = TRUE, null = "null")

# Stage 1: extraction from the source record
extract_v1 <- function(row) {
  ask_json(
    paste0(
      "Analyse this digital request record and generate structured metadata.\n",
      json_rules, "\nReturn a JSON object with the metadata keys only.\n\n",
      "Data dictionary:\n", paste(as.character(btw::btw(informant_data_dig_req)), collapse = "\n"),
      "\n\nSource record:\n", record_json(row)
    ),
    metadata_fields
  )
}

# Stages 2 and 3: validate the previous version against the source and refine it
validate_refine <- function(row, previous, stage_label) {
  ask_json(
    paste0(
      "Quality assurance review (", stage_label, "). Compare the metadata below with the original record.\n",
      "Check completeness, fidelity to the source, unsupported assumptions, factual errors,",
      " accuracy of themes and missed contextual information.\n", json_rules,
      "\nReturn a JSON object with two keys: \"findings\" (array of strings describing glaring omissions",
      " or errors; empty array if none) and \"metadata\" (the refined metadata object).\n\n",
      "Original record:\n", record_json(row), "\n\nMetadata to review:\n", to_json(previous)
    ),
    c("findings", "metadata")
  )
}

# Full three-stage pipeline for one row
process_row <- function(row) {
  v1 <- extract_v1(row)
  r2 <- if (!is.null(v1)) validate_refine(row, v1, "stage 2, version 1 -> version 2")
  v2 <- r2$metadata %||% v1
  r3 <- if (!is.null(v2)) validate_refine(row, v2, "stage 3, version 2 -> version 3")
  v3 <- r3$metadata %||% v2
  tibble::tibble(
    request_row_id = row$request_row_id,
    metadata_v1 = list(v1), findings_v2 = list(unlist(r2$findings)), metadata_v2 = list(v2),
    findings_v3 = list(unlist(r3$findings)), metadata_v3 = list(v3),
    model = model_name, processed_at = Sys.time()
  )
}

## Run (resumable: only unprocessed rows are analysed) ----------------
requests <- data_dig_req |> mutate(request_row_id = row_number(), .before = 1)
done <- if (file.exists(output_file)) readRDS(output_file) else NULL
todo <- requests |> filter(!request_row_id %in% done$request_row_id)

results <- purrr::map(seq_len(nrow(todo)), function(i) {
  message("Processing request ", i, " of ", nrow(todo))
  res <- process_row(as.list(todo[i, ]))
  res$source_record <- list(as.list(todo[i, ]))
  res
}) |> bind_rows()

all_results <- bind_rows(done, results)
dir.create(dirname(output_file), showWarnings = FALSE, recursive = TRUE)
saveRDS(all_results, output_file) # join back to data_dig_req via request_row_id
