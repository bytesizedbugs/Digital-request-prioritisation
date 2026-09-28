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
  info = "A unique persistent identifier assigned to the digital request, acting as the primary key for tracking records across systems."
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
    info = "The unique business identifier assigned to this demand by the source system of record (SOR). Critical for linking back to original submission records."
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
  info = "The organisational directorate responsible for submitting or managing this digital request, defining its primary department alignment."
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
    info = "The specific clinical board that reviewed and provided endorsement or guidance on this digital request."
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
  info = "The high-level strategic category or domain that the digital request falls under (e.g., 'Operational Efficiency', 'Patient Safety')."
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
    info = "The defined type or nature of the demand as per the source system's taxonomy (e.g., 'New Capability', 'Process Improvement')."
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
    info = "The assessed level of urgency for the request (e.g., 'High', 'Medium', 'Low'), requiring prompt attention or immediate action.",
    Items = "This column contains {list_urgency}."
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
    info = "A qualitative measure of the potential benefit or harm associated with the requested change. This assesses operational significance (Impact).",
    Items = "This column contains {list_impact}."
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
    info = "A standardised, qualitative rating assigned to the overall risk associated with implementing or not implementing this digital request (e.g., 'Low', 'Medium', 'High').",
    Items = "This column contains {list_risk_level}."
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
    info = "The strategic objective or pillar that the successful implementation of this request is intended to support (e.g., 'Patient Centricity', 'System Resilience').",
    Items = "This column contains {list_trust_strategy}."
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
    info = "The specific funding status assigned to the project (e.g., 'Fully Funded', 'Seed Funding Identified'). Confirms financial viability at various stages.",
    Items = "This column contains {list_funding_availability}."
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
  info = "A boolean or enumerated field indicating whether funding sources have been successfully identified and secured for the project scope.",
  Items = "This column contains {list_funding_sourced}."
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
    info = "A flag indicating the necessity for a formal, dedicated impact analysis (e.g., clinical/operational risk assessment) before proceeding with development or implementation.",
    Items = "This column contains {list_impact_analysis_required}."
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
  info = "The priority ranking determined and formalised by the Clinical Board, guiding the sequence of resource allocation for development (e.g., 1-Critical, 5-Low).",
  Items = "Numeric values."
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
    info = "The standardised numeric score representing the measured impact of the digital request on operations or patient care (higher number = higher perceived value/impact).",
    Items = "Numeric values."
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
    info = "The standardised numeric score representing the calculated or inherent risk level of the proposed solution (higher number = higher intrinsic risk).",
    Items = "Numeric values."
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
    info = "A count detailing the total number of significant updates or review cycles documented for this request's lifecycle. Acts as a measure of maturity/engagement.",
    Items = "Numeric values."
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
    info = "The official date and time when the digital request was formally initiated or submitted into the prioritisation system record. Key start metric.",
    Items = "Date-time values."
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
    info = "The date and time when the underlying digital request record was first created in the tracking system (System creation timestamp).",
    Items = "Date-time values."
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
    info = "The date and time on which the digital request status transitioned to 'Closed', marking its formal completion or archival in the system."
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
    info = "The finalised, user-facing title summarising the core need or capability addressed by the digital request."
  ) |>
  
  info_columns(
    columns = vars(background),
    Items = "Free-text field.",
    info = "Detailed narrative context providing the background and justification for why this digital request is necessary, detailing current system gaps or processes needing improvement."
  ) |>
  
  info_columns(
    columns = vars(benefits),
    Items = "Free-text field.",
    info = "A detailed description of the tangible or intangible benefits (e.g., time saved, revenue gained, safety improved) expected once the digital request is successfully implemented and operationalised."
  ) |>
  
  info_columns(
    columns = vars(objectives),
    Items = "Free-text field.",
    info = "The specific, measurable, and high-level objectives (e.g., 'Reduce average turnaround time by 15%', 'Automate X process') that the digital request is designed to achieve and measure success against."
  ) |>
  
  info_columns(
    columns = vars(project_scope),
    Items = "Free-text field.",
    info = "A clear statement outlining the physical or digital scope of work included in this phase (the 'in-scope' items). Excludes any out-of-scope elements."
  ) |>
  
  info_columns(
    columns = vars(deliverables),
    Items = "Free-text field.",
    info = "A list of all anticipated and defined tangible outputs or deliverables (e.g., 'API documentation', 'Updated SOPs', 'New reporting dashboard'). These items must be measurable."
  ) |>
  
  info_columns(
    columns = vars(requested_for),
    Items = "Staff names.",
    info = "The individual or service (e.g., 'Radiology Department', 'IT Support') that is the primary recipient of the proposed digital solution or workflow enhancement."
  ) |>
  
  info_columns(
    columns = vars(opened_by),
    Items = "Staff names.",
    info = "The name or department of the individual who initiated and authored this digital request record within the system."
  ) |>
  
  info_columns(
    columns = vars(assigned_to),
    Items = "Staff names.",
    info = "The individual or team currently holding ownership and responsibility for driving the progress of the digital request towards completion."
  ) |>
  
  info_columns(
    columns = vars(demand_manager),
    Items = "Staff names.",
    info = "The designated Demand Manager responsible for overseeing and guiding the overall progress of this digital request through the prioritisation lifecycle."
  ) |>
  
  info_columns(
    columns = vars(closed_by),
    Items = "Staff names.",
    info = "The name or department of the individual/party authorised to formally close and archive the digital request record in the system. Requires formal sign-off."
  ) |> 
  
  info_columns(
    columns = vars(business_justification),
    Items = "Free-text field.",
    info = "A concise explanation of the underlying business necessity or problem that necessitates this digital request, providing justification for resource allocation."
  ) |>
  
  info_columns(
    columns = vars(purpose),
    Items = "Free-text field.",
    info = "The overarching problem statement or area of improvement that this digital request aims to solve or address within the organisation's processes."
  ) |>
  
  info_columns(
    columns = vars(risk_identification),
    Items = "Free-text field.",
    info = "A comprehensive identification and description of potential risks (technical, clinical, operational) that could hinder the successful implementation or impact assessment of the request."
  ) |>
  
  info_columns(
    columns = vars(risk_monitoring),
    Items = "Free-text field.",
    info = "A detailed outline specifying the systematic methodology and actions planned to continuously monitor and mitigate all identified project risks throughout development and post-launch operations."
  ) |>
  
  info_columns(
    columns = vars(risk_prevention_management),
    Items = "Free-text field.",
    info = "Specific preventive measures, defined process changes, and required management controls designed to actively reduce the likelihood or severity of the identified project risks."
  ) |> 
  
  info_columns(
    columns = vars(previous_ref),
    Items = "Reference identifiers.",
    info = "A reference ID or unique identifier linking this request to a previous, foundational digital project or existing service that informed its current requirements. Crucial for lineage tracking."
  ) |>
  
  info_columns(
    columns = vars(downstream_teams_based_on_initial_analysis),
    Items = "Team names.",
    info = "A list of departments, services, and clinical teams that are anticipated to be involved in the design, build, or ongoing usage/maintenance of this digital request solution."
  ) |>
  
  info_columns(
    columns = vars(additional_comments),
    Items = "Free-text field.",
    info = "General administrative notes maintained by the PMO or stakeholders regarding operational issues, scope changes, or discussion points throughout the request lifecycle, outside of formal fields."
  ) |>
  
  info_columns(
    columns = vars(approval_history),
    Items = "Free-text field.",
    info = "A structured record or summary of formal governance approval decisions (e.g., meeting minutes, sign-off documents) that validate the request's progress through review stages."
  ) |>
  
  info_columns(
    columns = vars(assumptions),
    Items = "Free-text field.",
    info = "A clearly documented list of assumptions (e.g., 'Data quality in X source will remain consistent', 'Stakeholder Y will be available by Q3') that underpin the entire feasibility and planning process for this request."
  ) |>
  
  info_columns(
    columns = vars(clinical_risk_datix_ref),
    Items = "Reference identifiers.",
    info = "Unique reference numbers from established clinical risk management tools (e.g., Datix, InPhase, mandatory hospital databases) linked to this request's risk profile."
  ) |>
  
  info_columns(
    columns = vars(constraints),
    Items = "Free-text field.",
    info = "Any known organisational or technical limitations (e.g., 'Must use existing FHIR standard', 'Limited budget') that restrict the design choices or implementation options for this request."
  ) |>
  
  info_columns(
    columns = vars(contact_type),
    Items = "Contact method.",
    info = "The primary and preferred communication method (e.g., 'Email', 'Direct Call', 'Secure Portal Message') for follow-up communications regarding the status of this request."
  ) |>
  
  info_columns(
    columns = vars(demand),
    Items = "Free-text field.",
    info = "A consolidated view combining both the common name and the unique identifier used to reference this demand within the primary source operational system (e.g., 'Radiology Demand #2345')."
  ) |>
  
  info_columns(
    columns = vars(escalation),
    Items = "Escalation category.",
    info = "The current official escalation status of the request (e.g., 'Escalated to Board', 'Under Review by CIO'). Defines its current governance pathway and urgency level."
  ) |>
  
  info_columns(
    columns = vars(exclusions_from_scope),
    Items = "Free-text field.",
    info = "A definitive list of activities, features, or scope items that have been formally agreed upon to be handled by a separate project or process and are therefore explicitly outside the scope of this digital request."
  ) |>
  
  info_columns(
    columns = vars(imported_notes),
    Items = "Free-text field.",
    info = "Important contextual notes or summaries pulled forward into this record from previous systems (e.g., 'Predecessor system noted high dependency on X API'). Helps trace history and prevent assumption creep."
  ) |>
  
  info_columns(
    columns = vars(interface),
    Items = "Free-text field.",
    info = "A description of any required technical integrations, API connections, system interoperability standards (e.g., HL7 FHIR), or system linkages that must be achieved for the request to function correctly."
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

