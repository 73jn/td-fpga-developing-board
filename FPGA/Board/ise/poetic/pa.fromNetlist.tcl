
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name poetic -dir "C:/Users/jean.nanchen/Downloads/td-fpga-developing-board/FPGA/Board/ise/poetic/planAhead_run_2" -part xc6slx150fgg484-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/jean.nanchen/Downloads/td-fpga-developing-board/FPGA/Board/ise/poetic/poetic_circuit.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/jean.nanchen/Downloads/td-fpga-developing-board/FPGA/Board/ise/poetic} }
set_property target_constrs_file "C:/Users/jean.nanchen/Downloads/td-fpga-developing-board/FPGA/Board/concat/poetic.ucf" [current_fileset -constrset]
add_files [list {C:/Users/jean.nanchen/Downloads/td-fpga-developing-board/FPGA/Board/concat/poetic.ucf}] -fileset [get_property constrset [current_run]]
link_design
