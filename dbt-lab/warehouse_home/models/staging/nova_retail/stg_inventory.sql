with source as (
    select * from {{ source('raw_nova_retail', 'inventory') }}
),

renamed as (
    select
        {{ clean_and_cast('id', 'string') }} as inventory_id,
        {{ clean_and_cast('product', 'string') }} as product_name,
        {{ clean_and_cast('price', 'numeric') }} as unit_price,
        {{ clean_and_cast('store_location', 'string') }} as store_name,
        {{ clean_and_cast('_sdc_extracted_at', 'timestamp') }} as loaded_at
    from source
), -- <--- THIS COMMA IS THE KEY

flags as (
    select 
        *,
        case 
            when unit_price = 0 then '🚩 ERROR: INVALID PRICE' 
            else '✅ OK' 
        end as price_quality_flag,
        case 
            when product_name is null then '🚩 ERROR: MISSING NAME' 
            else '✅ OK' 
        end as naming_quality_flag
    from renamed
)

select * from flags