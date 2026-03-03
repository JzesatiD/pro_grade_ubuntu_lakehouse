{% macro clean_and_cast(column_name, type='string') %}
    
    {%- if type == 'string' -%}
        {# Just a clean trim and NULL handling - no aggressive regex #}
        nullif(trim({{ column_name }}), '')
    
    {%- elif type == 'numeric' -%}
        {# Keep the regex here because it specifically hunts for non-numeric junk #}
        round(
            case 
                when {{ column_name }} ~ '[^0-9.]' then 0 
                else {{ column_name }}::numeric 
            end, 2)
            
    {%- elif type == 'timestamp' -%}
        {{ column_name }}::timestamp
        
    {%- endif -%}

{% endmacro %}