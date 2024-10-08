#!/bin/bash

# Define the source and output directory (same directory)
data_dir="./"

# Create a temporary directory for intermediate files
temp_dir="./temp_cdd"
mkdir -p "$temp_dir"

# List of models to process
models=("MRI-ESM2-0" "NESM3" "TaiESM1")

# Loop through each model
for model in "${models[@]}"; do
    echo "Processing model: $model"
    
    # Loop over the .nc files for the period from 1985 to 2014
    for year in {1985..2014}; do
        input_file="pr_day_${model}_historical_r1i1p1f1_gn_${year}_Africa.nc"
        temp_file="${temp_dir}/temp_${model}_${year}.nc"
        converted_file="${temp_dir}/converted_${model}_${year}.nc"
        cdd_file="${temp_dir}/cdd_pr_day_${model}_historical_${year}_Africa.nc"

        # Check if the input file exists
        if [ -f "$input_file" ]; then
            echo "Processing file: $input_file"

            # Apply the sellonlatbox command for West Africa
            cdo -L -O sellonlatbox,-20,20,0,30 "$input_file" "$temp_file"

            # Convert to mm/day (from m/s to mm/day)
            cdo -L -O mulc,86400 "$temp_file" "$converted_file"  # Convert m/s to mm/day

            # Calculate the CDD from the converted file
            cdo -L -O eca_cdd,1 "$converted_file" "$cdd_file"

            echo "Finished processing file: $input_file"
        else
            echo "File not found: $input_file"
        fi
    done

    # Merge all CDD files for the current model in the temporary directory
    final_output_file="cdd_pr_day_${model}_historical_1985_2014_Africa.nc"
    cdo -L -O mergetime "$temp_dir/cdd_pr_day_${model}_historical_*.nc" "$final_output_file"

    echo "All CDD files for ${model} merged into: $final_output_file"
done

# Optionally: remove the temporary directory
rm -rf "$temp_dir"

