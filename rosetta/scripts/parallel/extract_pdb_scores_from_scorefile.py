from collections import defaultdict

# Dictionary to store lines for each unique description pattern
score_lines_dict = defaultdict(list)

with open("MSscore.sc", "r") as file:
    lines = file.readlines()

# Filter and group lines based on the description column
for line in lines:
    description_start = line.find("new_") + len("new_")
    description_end = line.find("_0001_MYD88", description_start)
    
    if description_start != -1 and description_end != -1:
        description_pattern = line[description_start:description_end]
        score_lines_dict[description_pattern].append(line.strip())

# Write the lines for each description pattern to separate files
for description_pattern, lines in score_lines_dict.items():
    output_filename = f"score_file_{description_pattern}.txt"
    
    with open(output_filename, "w") as file:
        file.write("\n".join(lines))
