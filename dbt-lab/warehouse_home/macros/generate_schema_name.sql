{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    
    {# If the model is in the 'staging' folder #}
    {%- if 'staging' in node.fqn -%}
        {# Grab the project folder name (e.g., 'nova_retail') #}
        {%- set folder_name = node.fqn[2] -%}
        {{ 'stg_' ~ folder_name | trim }}
    
    {%- elif custom_schema_name is not none -%}
        {{ custom_schema_name | trim }}
    
    {%- else -%}
        {{ default_schema }}
    {%- endif -%}
{%- endmacro %}