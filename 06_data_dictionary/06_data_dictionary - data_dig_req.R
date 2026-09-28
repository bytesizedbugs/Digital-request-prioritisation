# Data Dictionary — data_dig_req
#
# Uses {pointblank} to create and maintain a data dictionary (informant object)
# for the data_dig_req table.
#
# Workflow:
#   1. Run prerequisite wrangling script to create data_dig_req.
#   2. Run this script to (re)generate the informant and write the YAML.
#   3. Commit the updated YAML file to version control.
#
# Output: 03_data_dictionary/data_dig_req.yml
#
# See: https://rstudio.github.io/pointblank/articles/INFO-1.html
# IMPORTANT: The output YAML must not contain patient identifiable information.

# Packages ----------------------------------------------------------------

library(pointblank)

# Prerequisite R scripts --------------------------------------------------

# Ensure data_dig_req exists in the environment.
# If not already loaded, uncomment and run the daisychain script:
# source("./01_src/03_wrangle/03_wrangle - daisychain.R")

# Create informant --------------------------------------------------------

informant_data_dig_req <- pointblank::create_informant(
  tbl = ~ data_dig_req,  # Lazy evaluation with `~`
  tbl_name = "data_dig_req",
  label = "Digital Request Data Table"
) |>

  # Table-level information -----------------------------------------------

  info_tabular(
    Description = paste(
      "This table contains the wrangled digital request data"
    ),
    Source = paste(
      "Project Management Office (PMO) digital request extract"
    ),
    `Update process` = paste(
      " TBC by PMO "
    ),
    `Key join columns` = "nil",
    Linkage = paste(
      " This table is not linked to any other tables in the data warehouse "
    )
  ) |>

info_columns(
  columns = vars(digital_request_number),
  Items = "This column contains {list_digital_request_number}.",
  info = "Unique identifier for the digital request."
) |>
  
  info_snippet(
    snippet_name = "list_digital_request_number",
    fn = snip_list(
      column = "digital_request_number",
      limit = 10,
      sorting = "inorder",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(effective_number),
    Items = "This column contains {list_effective_number}.",
    info = "Effective demand identifier within the source system."
  ) |>
  
  info_snippet(
    snippet_name = "list_effective_number",
    fn = snip_list(
      column = "effective_number",
      limit = 10,
      sorting = "inorder",
      na_rm = TRUE
    )
  ) |>
  
info_columns(
  columns = vars(directorate),
  Items = "This column contains {list_directorate}.",
  info = "Directorate associated with the request."
) |>
  
  info_snippet(
    snippet_name = "list_directorate",
    fn = snip_list(
      column = "directorate",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(clinical_board),
    Items = "This column contains {list_clinical_board}.",
    info = "Clinical board associated with the request."
  ) |>
  
  info_snippet(
    snippet_name = "list_clinical_board",
    fn = snip_list(
      column = "clinical_board",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
info_columns(
  columns = vars(category),
  Items = "This column contains {list_category}.",
  info = "High-level categorisation of the request."
) |>
  
  info_snippet(
    snippet_name = "list_category",
    fn = snip_list(
      column = "category",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(type),
    Items = "This column contains {list_type}.",
    info = "Demand type recorded in the source system."
  ) |>
  
  info_snippet(
    snippet_name = "list_type",
    fn = snip_list(
      column = "type",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(urgency),
    Items = "This column contains {list_urgency}.",
    info = "Urgency assigned to the request."
  ) |>
  
  info_snippet(
    snippet_name = "list_urgency",
    fn = snip_list(
      column = "urgency",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(impact),
    Items = "This column contains {list_impact}.",
    info = "Qualitative assessment of impact."
  ) |>
  
  info_snippet(
    snippet_name = "list_impact",
    fn = snip_list(
      column = "impact",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(risk_level),
    Items = "This column contains {list_risk_level}.",
    info = "Overall qualitative risk level."
  ) |>
  
  info_snippet(
    snippet_name = "list_risk_level",
    fn = snip_list(
      column = "risk_level",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(trust_strategy),
    Items = "This column contains {list_trust_strategy}.",
    info = "Trust strategic objective supported by the request."
  ) |>
  
  info_snippet(
    snippet_name = "list_trust_strategy",
    fn = snip_list(
      column = "trust_strategy",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(funding_availability),
    Items = "This column contains {list_funding_availability}.",
    info = "Funding status recorded for the request."
  ) |>
  
  info_snippet(
    snippet_name = "list_funding_availability",
    fn = snip_list(
      column = "funding_availability",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
info_columns(
  columns = vars(funding_sourced),
  Items = "This column contains {list_funding_sourced}.",
  info = "Indicates whether funding has been identified or secured."
) |>
  
  info_snippet(
    snippet_name = "list_funding_sourced",
    fn = snip_list(
      column = "funding_sourced",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(impact_analysis_required),
    Items = "This column contains {list_impact_analysis_required}.",
    info = "Indicates whether a formal impact analysis is required."
  ) |>
  
  info_snippet(
    snippet_name = "list_impact_analysis_required",
    fn = snip_list(
      column = "impact_analysis_required",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
info_columns(
  columns = vars(board_priority_rank),
  Items = "Numeric values.",
  info = "Priority ranking assigned by the Clinical Board."
) |>

  info_snippet(
    snippet_name = "list_board_priority_rank",
    fn = snip_list(
      column = "board_priority_rank",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(impact_value),
    Items = "Numeric values.",
    info = "Numeric impact score."
  ) |>

  info_snippet(
    snippet_name = "list_impact_value",
    fn = snip_list(
      column = "impact_value",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(risk_score),
    Items = "Numeric values.",
    info = "Numeric risk score."
  ) |>
  
  info_snippet(
    snippet_name = "list_risk_score",
    fn = snip_list(
      column = "risk_score",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(updates),
    Items = "Numeric values.",
    info = "Count of recorded updates."
  ) |>
  
  info_snippet(
    snippet_name = "list_updates",
    fn = snip_list(
      column = "updates",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
info_columns(
  columns = vars(opened),
  Items = "Date-time values.",
  info = "Date and time the request was opened."
) |>
  
  info_snippet(
    snippet_name = "list_opened",
    fn = snip_list(
      column = "opened",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(created),
    Items = "Date-time values.",
    info = "Date and time the request record was created."
  ) |>
  
  info_snippet(
    snippet_name = "list_created",
    fn = snip_list(
      column = "created",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(closed),
    Items = "Date-time values.",
    info = "Date and time the request was closed."
  ) |>
  
  info_snippet(
    snippet_name = "list_closed",
    fn = snip_list(
      column = "closed",
      limit = 10,
      sorting = "infreq",
      na_rm = TRUE
    )
  ) |>
  
  info_columns(
    columns = vars(project_title),
    Items = "Free-text field.",
    info = "Title of the digital request."
  ) |>
  
  info_columns(
    columns = vars(background),
    Items = "Free-text field.",
    info = "Background and context supporting the request."
  ) |>
  
  info_columns(
    columns = vars(benefits),
    Items = "Free-text field.",
    info = "Expected benefits of the proposed work."
  ) |>
  
  info_columns(
    columns = vars(objectives),
    Items = "Free-text field.",
    info = "Objectives the request aims to achieve."
  ) |>
  
  info_columns(
    columns = vars(project_scope),
    Items = "Free-text field.",
    info = "Description of work included within scope."
  ) |>
  
  info_columns(
    columns = vars(deliverables),
    Items = "Free-text field.",
    info = "Expected outputs or deliverables."
  ) |>
  
  info_columns(
    columns = vars(requested_for),
    Items = "Staff names.",
    info = "Person or service for whom the request was submitted."
  ) |>
  
  info_columns(
    columns = vars(opened_by),
    Items = "Staff names.",
    info = "Person who created the request."
  ) |>
  
  info_columns(
    columns = vars(assigned_to),
    Items = "Staff names.",
    info = "Person currently assigned responsibility for the request."
  ) |>
  
  info_columns(
    columns = vars(demand_manager),
    Items = "Staff names.",
    info = "Demand manager responsible for the request."
  ) |>
  
  info_columns(
    columns = vars(closed_by),
    Items = "Staff names.",
    info = "Person who closed the request."
  ) |> 
  
  info_columns(
    columns = vars(business_justification),
    Items = "Free-text field.",
    info = "Business rationale supporting the request."
  ) |>
  
  info_columns(
    columns = vars(purpose),
    Items = "Free-text field.",
    info = "Purpose of the request or project."
  ) |>
  
  info_columns(
    columns = vars(risk_identification),
    Items = "Free-text field.",
    info = "Description of identified project risks."
  ) |>
  
  info_columns(
    columns = vars(risk_monitoring),
    Items = "Free-text field.",
    info = "Approach to monitoring identified risks."
  ) |>
  
  info_columns(
    columns = vars(risk_prevention_management),
    Items = "Free-text field.",
    info = "Risk mitigations and management controls."
  ) |> 
  
  info_columns(
    columns = vars(previous_ref),
    Items = "Reference identifiers.",
    info = "Reference to a predecessor or related request."
  ) |>
  
  info_columns(
    columns = vars(downstream_teams_based_on_initial_analysis),
    Items = "Team names.",
    info = "Teams identified during initial analysis as likely contributors to delivery."
  ) |>
  
  info_columns(
    columns = vars(additional_comments),
    Items = "Free-text field.",
    info = "Additional comments recorded during request management."
  ) |>
  
  info_columns(
    columns = vars(approval_history),
    Items = "Free-text field.",
    info = "Audit trail of approval decisions recorded within the source system."
  ) |>
  
  info_columns(
    columns = vars(assumptions),
    Items = "Free-text field.",
    info = "Assumptions used when assessing, planning, or delivering the request."
  ) |>
  
  info_columns(
    columns = vars(clinical_risk_datix_ref),
    Items = "Reference identifiers.",
    info = "Associated Datix, InPhase, or other clinical risk-management reference numbers."
  ) |>
  
  info_columns(
    columns = vars(constraints),
    Items = "Free-text field.",
    info = "Constraints that may affect delivery of the request."
  ) |>
  
  info_columns(
    columns = vars(contact_type),
    Items = "Contact method.",
    info = "Preferred contact method recorded for the request."
  ) |>
  
  info_columns(
    columns = vars(demand),
    Items = "Free-text field.",
    info = "Combined demand title and identifier as recorded in the source system."
  ) |>
  
  info_columns(
    columns = vars(escalation),
    Items = "Escalation category.",
    info = "Escalation status assigned to the request."
  ) |>
  
  info_columns(
    columns = vars(exclusions_from_scope),
    Items = "Free-text field.",
    info = "Activities explicitly excluded from the scope of the request or project."
  ) |>
  
  info_columns(
    columns = vars(imported_notes),
    Items = "Free-text field.",
    info = "Historical notes imported from predecessor systems or records."
  ) |>
  
  info_columns(
    columns = vars(interface),
    Items = "Free-text field.",
    info = "Systems interfaces, integrations, or interoperability requirements associated with the request."
  ) |>
  
  info_columns(
    columns = vars(previous_stage),
    Items = "Workflow stage identifiers.",
    info = "Workflow stage occupied prior to the current stage."
  ) |>
  
  info_columns(
    columns = vars(reporting_resource),
    Items = "Free-text field.",
    info = "Reporting requirements, reporting processes, or reporting resources associated with the request."
  ) |>
  
  info_columns(
    columns = vars(work_notes),
    Items = "Free-text field.",
    info = "Audit trail and operational notes recorded during request management."
  ) |>

  # Incorporate ---------------------------------

incorporate()

# Write the informant to YAML ---------------------------------------------

if (!dir.exists("./03_data_dictionary")) {
  dir.create(
    "./03_data_dictionary",
    recursive = TRUE
  )
}

yaml_write(
  informant_data_dig_req,
  filename = "data_dig_req.yml",
  path = "./03_data_dictionary"
)

# View in browser (optional) ----------------------------------------------

informant_data_dig_req
