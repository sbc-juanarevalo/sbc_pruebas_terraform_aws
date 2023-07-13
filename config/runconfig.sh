#!/bin/bash

# Declarar un array para almacenar las variables
variables=()

# Leer el archivo de entrada y almacenar las variables en el array
while IFS= read -r line; do
    # Eliminar la indentación y los dos puntos de cada línea
    line="${line//      /}" # Reemplazar la tabulación por espacios (ajusta según la indentación utilizada)
    line="${line/:/}"

    # Agregar la variable al array
    variables+=("$line")
done < "config.yml"

# Crear un nuevo archivo para guardar la salida
output_file="variables.sh"

# Verificar si el archivo de salida existe y eliminarlo si es el caso
if [[ -f "$output_file" ]]; then
    rm "$output_file"
fi

# Ciclo for para variar la línea 3 cada 4 líneas y guardar la salida en el archivo
for ((i = 2; i < ${#variables[@]}; i += 4)); do
    # Verificar si la siguiente línea existe
    if ((i + 1 < ${#variables[@]})); then
        # Concatenar las líneas 1, 2, la línea actual y la siguiente línea en una sola línea, separadas por "_"
        combined_lines="${variables[0]}_${variables[1]}_${variables[i]}_${variables[i+1]}"

        # Obtener la última palabra en la línea combinada
        last_word="${combined_lines##*[![:alnum:]]}"

        # Colocar un "=" a tres letras antes de la última palabra
        combined_lines="${combined_lines%$last_word}=$last_word"

        # Eliminar los espacios en la línea combinada
        combined_lines="${combined_lines// /}"

        # Guardar la línea combinada en el archivo de salida
        echo "$combined_lines" >> "$output_file"

        # Concatenar las líneas 1, 2, la línea actual y la siguiente línea en una sola línea, separadas por "_"
        combined_lines="${variables[0]}_${variables[1]}_${variables[i]}_${variables[i+2]}"

        # Obtener la última palabra en la línea combinada
        last_word="${combined_lines##*[![:alnum:]]}"

        # Colocar un "=" a tres letras antes de la última palabra
        combined_lines="${combined_lines%$last_word}=$last_word"

        # Eliminar los espacios en la línea combinada
        combined_lines="${combined_lines// /}"

        # Guardar la línea combinada en el archivo de salida
        echo "$combined_lines" >> "$output_file"

        # Concatenar las líneas 1, 2, la línea actual y la siguiente línea en una sola línea, separadas por "_"
        combined_lines="${variables[0]}_${variables[1]}_${variables[i]}_${variables[i+3]}"

        # Obtener la última palabra en la línea combinada
        last_word="${combined_lines##*[![:alnum:]]}"

        # Colocar un "=" a tres letras antes de la última palabra
        combined_lines="${combined_lines%$last_word}=$last_word"

        # Eliminar los espacios en la línea combinada
        combined_lines="${combined_lines// /}"

        # Guardar la línea combinada en el archivo de salida
        echo "$combined_lines" >> "$output_file"
    else
        # Si no hay siguiente línea, guardar la línea actual en el archivo de salida
        echo "${variables[i]}" >> "$output_file"
    fi
done

chmod 777 $output_file

echo "Se ha creado exitosamente el archivo $output_file"