# VMD script to visualize molecular orbitals from a Molden file

# Define the constant directory
set dir "C:/Users/Woon/Documents/DICC/Hamsu/EHBIPOPh/"

# Search for the first .molden file in the directory
set molden_files [glob -nocomplain ${dir}*.molden]
if {[llength $molden_files] == 0} {
    puts "No .molden files found in the directory."
    exit
}
set molden_file [lindex $molden_files 0]
puts "Loading first found molden file: $molden_file"

# Count the number of "Occup= 2.0" in the Molden file
set fp [open $molden_file r]
set n 0
while {[gets $fp line] >= 0} {
    if {[string match *Occup=*\ 2.0* $line]} {
        incr n
    }
}
close $fp
puts "Number of orbitals with Occup= 2.0: $n"

# Check if there are enough orbitals to proceed
if {$n < 1} {
    puts "Not enough orbitals to visualize."
    exit
}

set start_index $n
set end_index [expr $n - 5]

# Load the first found Molden file and capture the molecule ID
set molid [mol new $molden_file type molden]

# Set display properties
color Display Background white
display projection Orthographic
axes location off

# Display the molecule structure using bond drawing method and type coloring method
mol representation Bonds 0.1 15
mol color Type
mol addrep $molid
mol delrep 0 $molid

# Function to visualize and save snapshot for a given orbital index
# Added start_index as a parameter
proc visualize_orbital {molid index dir start_index} {

    # Display the isosurface for the orbital with positive isovalue and ColorID 0
    set isoval 0.03
    mol representation Orbital $isoval $index 0 0 0.075 1 6 0 0 1
    mol color ColorID 0
    mol addrep $molid

    # Display the isosurface for the orbital with negative isovalue and ColorID 1
    set isoval -0.03
    mol representation Orbital $isoval $index 0 0 0.075 1 6 0 0 1
    mol color ColorID 1
    mol addrep $molid

    # Adjust the view
    rotate x by 0
    rotate y by 0
    rotate z by 0
    display resize 1920 1080

    # Set filename for saving the image
    if {$index == $start_index} {
        set filename "${dir}HOMO.bmp"
    } else {
        set n [expr {$start_index - $index}]
        set filename "${dir}HOMO-$n.bmp"
    }

    # Render and save the visualization to a BMP image
    render options snapshot
    render snapshot $filename

    # Wait for a longer time to ensure rendering completes
    after 5000

    # Remove the added representations to reset for the next orbital
    mol delrep 1 $molid
    after 5000
    mol delrep 1 $molid
}

# Loop through orbital indices from n to (n-5) and visualize each
for {set index $start_index} {$index > $end_index} {incr index -1} {
    puts "Visualizing orbital index: $index"
    visualize_orbital $molid $index $dir $start_index
}
