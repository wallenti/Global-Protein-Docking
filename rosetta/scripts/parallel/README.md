ROSETTA PARALELL GLOBAL DOCKING
===============================

Goal
----

This will lead starting from dowloading the pdbs you want to dock, to the parallel gloabl docking of the canditate structures.

Input
-----

Before you start
----------------

1. You should download ROSETTA.

2. Copy the reppsitory into your rosetta folder

	
3. Downloading the enviroments: 
	-got to [enviroments] in the scripts folder
	-type: conda env create -f pymol_jw.yml (for pymol enviroment)
	-type: conda env create -f rosetta_jw.yml (for rosetta enviroment)

4. Have a list of Protein IDs you wat to dock ready.

5. Have the Docking partner A (i.e. The Mydosome complex that the proteins from your list will be docked to) in a relaxed state

	relaxing a single PDB [relax_cst.sh]: 
	in script: adjust #SBATCH -D (where the job_file.out will be stored)
		  adjust -s (path to input structure)
		  adjust -out:prefix (path to output structure)	
	activate rosetta: conda activate rosetta_jw
	execute script: sbatch relax_cst.sh


Preparing multiple docking partners (docking parnter B) in parallel
--------------------------------------------------------------------

1. For getting crystall structures from uniprot IDs:
Uniprot IDs where converted to pdb IDs using the uniprot mapping tool: [id-mapping]

2. store the pdb IDs as a csv file in [input]

3. Download pdb structures once you have the pdb IDs

	pdbs where downloaded using [pdb_id_to_structure.py]:
	Adjust the paths in csv_file_path to match the location of your csv file containing the pdb IDs.
	Activate rosetta: conda activate rosetta_jw
	Execute the script: python pdb_id_to_structure.py & 

4. organize nto subfolders containing 100 pdbs each [python organize_pdbs_100.py]
     	In script: Adjust the path of pdb_directory
	execute: python organize_pdbs_100.py &


5.rename the chains of downloaded pdbs to G ALL chains will be named G also pdbs with mulstiple chains [parallel_rename.py]
	in script: adjust input_folder and output_folder paths
		   cmd.alter('all', 'chain="G"') # adjust if you have more ore less tahn 6 chain in docking partner A
	activate pymol: conda activate pymol_jw
	execute script: pymol -c parallel_rename.py


6. relax structures [parallel_relax_cst.sh]
 	in script: adjust #SBATCH -D '/path/to/rosetta/output/subfolder_1_relaxed'
	rosetta_scripts="/path/to/rosetta/main/source/bin/rosetta_scripts.mpi.linuxgccrelease"
	protocol_file="/path/to/rosetta/parallel/scripts/relax_cst.xml"
	output_directory="/path/to/rosetta/input/subfolder_1_relaxed"	
	activate rosetta: conda activate rosetta_jw
	execute script: sbatch parallel_relax_cst.sh



Preparing Docking Partner A i.e. the Mydosome protein complex
--------------------------------------------------------------

Optional: 1.1:  Isolate chains you want [parallel_chain_iso.sh]
	inscript: adjust input_directory and output_directory
	activate pymol: conda activate pymol_jw
	execute the script: parallel_chain_iso.sh
	
1. Structure should be stored at /path/to/rosetta/input/docking_partner_A


Merge and dock pdbs
-------------------

1. Merge docking partner A and B [parallel_merge.sh]
	in script: input_directory="/path/to/rosetta/input/subfolder_1_relaxed"
		   output_directory="/path/to/rosetta//path/to/rosetta/input/subfolder_1_relaxed"
		   fixed_pdb_file="/path/to/rosetta/input/docking_partner_A"		
	activate pymol: conda activate pymol_jw
	execute script: sbatch parallel_merge.sh

2. docking [optimize_parallel_2_fast_glob_dock_lo_ml.sh]
	in script: adjust #SBATCH -D '/path/to/rosetta/output/subfolder_1'
	                #SBATCH --mail-user=your@email.com
			 cd /path/to/rosetta/scripts/parallel
			pdb=$(ls /path/to/rosetta//path/to/rosetta/input/subfolder_1_relaxed/*.pdb
			output_subdirectory="/path/to/rosetta/output/subfolder_1/docked_$SLURM_ARRAY_TASK_ID"
			/path/to/rosetta/main/source/bin/docking_protocol.mpi.linuxgccrelease

	in flag file [parallel_glob.flags]: adjust -scorefile subfolder1score.sc #adjust to the folder your in its importnant to always cahnge the name as otherwise the scores will be mixed with former runs
					     	   -docking:partners ABCDEF_G #here you have to adjust which chains are docked the pdb will be split before and after the _ so in this example G is docked to ABCDEF
		
	activate rosetta: conda activate rosetta_jw

	execute script: sbatch optimize_parallel_2_fast_glob_dock_lo_ml.sh   


	the scorefile will be stored where the script is executed

3. Extract scores [extract_pdb_scores_from_scorefile.py]
	in script: adjust	with open("MSscore.sc", "r") as file: #adjust name of score file
				description_start
				description_end         #so that the name of the protein that is dockied is between these two components. In this case the descriptions look like this: new_pdbID_0001_MYD88 pdbID will be the name of the score file

	scorefiles will be stored where script is executed	




<!-- Links -->
[pdb_id_to_structure.py](./pdb_id_to_structure.py)
[id-mapping]: https://www.uniprot.org/id-mapping
[input]: ../../input
[enviroments]: ../enviroments
[python organize_pdbs_100.py]: ./python organize_pdbs_100.py
[parallel_rename.py]: ./parallel_rename.py
[parallel_chain_iso.sh]: ./parallel_chain_iso.sh
[relax_cst.sh]: ../../glob_dock_single_run/sbatch relax_cst.sh
[parallel_merge.sh]: ./parallel_merge.sh
[parallel_relax_cst.sh]: ./parallel_relax_cst.sh
[optimize_parallel_2_fast_glob_dock_lo_ml.sh]: ./optimize_parallel_2_fast_glob_dock_lo_ml.sh
[parallel_glob.flags]: ./parallel_glob.flags
[extract_pdb_scores_from_scorefile.py]: ./extract_pdb_scores_from_scorefile.py

<!-- Footnotes-->




