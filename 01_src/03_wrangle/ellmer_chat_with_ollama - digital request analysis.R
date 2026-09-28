models_ollama(base_url = "http://localhost:11434", credentials = NULL)

## Prompt file import ----------------
# Add error handling for file reading
prompt_file <- file.path(here::here("01_src", "03_wrangle", "Prompts", "prompt-digital-request-analysis.md"))
if (!file.exists(prompt_file)) {
  stop("Prompt file not found: ", prompt_file)
}
prompt_template <- paste(readLines(prompt_file), collapse = "\n")

## Check if Ollama is running ----------------
library(httr)
base_url <- Sys.getenv("OLLAMA_BASE_URL", "http://localhost:11434")

# Check if Ollama process is running (optional - may not work on all systems)
tryCatch({
  system_result <- system("ollama --version", intern = TRUE)
  cat("✓ Ollama version:", system_result[1], "\n")
}, error = function(e) {
  cat("⚠ Warning: Could not verify Ollama installation\n")
})

# If you need to substitute variables in your prompt
# system_prompt <- glue::glue(prompt_template, .open = "{{", .close = "}}")
system_prompt <- glue::glue(
  prompt_template,
  .open = "<<",
  .close = ">>"
)

chat <- chat_ollama(
  system_prompt = system_prompt,
  base_url = base_url,
  model = "gemma4", # "qwen3.5", # "gemma3:1b", #"qwen3:30b"
  params = NULL,
  api_args = list(
    options = list(num_ctx = 32768) # Increase to 8k, 32k, etc. 32768 | 8192
  ), #You can set a global default context for the Ollama server by setting the environment variable OLLAMA_CONTEXT_LENGTH (e.g., OLLAMA_CONTEXT_LENGTH=8192 ollama serve), though individual models may still cap this based on their internal design
  echo = "output", # "none", "output", "all"
  api_key = NULL,
  credentials = NULL,
  api_headers = character()
)

chat_output <- chat$chat(btw(
  data_dig_req |> head(1) |> skim(),
  data_dig_req |> head(1),
  "Help me analyse this digital request record and generate structured metadata "
))

chat_output
