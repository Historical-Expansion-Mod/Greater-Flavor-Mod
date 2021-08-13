#script to generate the decisions and localization for gtfo (release vassal) decisions
#gtfodump.txt goes in decisions\gtfo.txt
#gtfodump.csv goes in 00_NMM_gtfo.csv
infile = open("countries.txt", "r")
outfile = open("gtfodump.txt","w")
outfile2 = open("gtfodump.csv","w")
for line in infile:
    if len(line) > 5:
        if line[5] == "=":
            tag = line[0:3]
            if tag != "REB":
                newline = "gtfo_" + tag + " = { picture = gtfo alert = no potential = { has_country_flag = gtfo NOT = { has_country_flag = gtfo_switch } " + tag + " = { vassal_of = THIS NOT = { substate_of = THIS } } } allow = { ai = no } effect = { prestige = -20 release_vassal = " + tag + " diplomatic_influence = { who = " + tag + " value = -100 } } } \n"
                newline2 = "gtfo_" + tag + "_switch = { picture = gtfo alert = no potential = { has_country_flag = gtfo has_country_flag = gtfo_switch " + tag + " = { vassal_of = THIS NOT = { substate_of = THIS } } } allow = { ai = no } effect = { release_vassal = " + tag + " diplomatic_influence = { who = " + tag + " value = -100 } change_tag_no_core_switch = " + tag + " } } \n"
                outfile.write(newline)
                outfile.write(newline2)
                country = line.split("/")[1].split(".")[0]
                newline = "gtfo_" + tag + "_title;Grant "+ country +" Independence;;;;;;;;;;;;x,,\n"
                newline2 = "gtfo_" + tag + "_desc;We've had a good run, but it's time to end our rulership of " + country + ": if you love something, let it go!;;;;;;;;;;;;x\n"
                newline3 = "gtfo_" + tag + "_switch_title;Grant "+ country +" Independence;;;;;;;;;;;;x,,\n"
                newline4 = "gtfo_" + tag + "_switch_desc;We've had a good run, but it's time to end our rulership of " + country + ": if you love something, let it go!;;;;;;;;;;;;x\n"
                outfile2.write(newline)
                outfile2.write(newline2)
                outfile2.write(newline3)
                outfile2.write(newline4)

infile.close()
outfile.close()
outfile2.close()
