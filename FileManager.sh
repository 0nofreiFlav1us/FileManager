#!/bin/bash

# ====================== BACKUP AVANSAT DE FISIERE

# Setare out.log
path_curent=$(pwd)
path_log="/home/onofreiflavius/Documents/backup_so_b"
path_exista_deja=1
data_curenta=$(date)
if [ ! -f "$path_log/out.log" ]; then
    mkdir -p "$path_log"
    touch "$path_log/out.log"
    path_exista_deja=0
fi

path_log="$path_log/out.log"
if [ "$path_exista_deja" -eq 0 ]; then
    echo -e "$data_curenta\nFisierul log a fost creat cu succes!" > "$path_log"
else
    echo -e "\n$data_curenta" >> "$path_log"    
fi

#---------------------------------START OPTIUNI---------------------------------#

debug="off"

informatii_help() {
    echo "-Help-"
    echo
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -u, --usage         Show usage information"
    echo "  --debug=on          Enable debugging mode (default: off)"
    echo "  --debug=off         Disable debugging mode"
}


informatii_usage() {
    echo "This script processes command-line options for help, usage, and debugging."
    echo "Options are as follows:"
    echo "  -h, --help          Display this help message"
    echo "  -u, --usage         Display usage information"
    echo "  --debug=on          Enable debugging output"
    echo "  --debug=off         Disable debugging output"
}


OPTIUNI=$(getopt -o hu -l help,usage,debug: -- "$@")

if [ $? != 0 ]; then
    echo "Optiuni invalide!" >&2 | tee -a "$path_log"
    exit 1
fi

eval set -- "$OPTIUNI"

while true; do
    case "$1" in
        -h | --help)
            informatii_help
            exit 0
          ;;
        -u | --usage)
            informatii_usage
            exit 0
            ;;
        --debug)
            case "$2" in
                on)
                    debug="on"
                    echo -e "Debugging activat!\n" | tee -a "$path_log"
                    shift 2
                    ;;
                off)
                    debug="off"
                    echo "Debugging dezactivat!" | tee -a "$path_log"
                    shift 2
                    ;;
                *)
                    echo "Argument invalid pentru --debug. Foloseste 'on' sau 'off'." >&2 | tee -a "$path_log"
                    exit 1
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Optiune neasteptata: $1" >&2 | tee -a "$path_log"
            exit 1
            ;;
    esac
done

if [ "$debug" == "on" ]; then
    set -x
fi

#---------------------------------END OPTIUNI---------------------------------#

#------------------------------START CONFIGURARE------------------------------#

path_stergere=""
terminatie_redenumire=""
linie_editare_continut=""
git_repo=""

configurare_path_stergere() {
    clear

    if [ -z "$path_stergere" ]; then
        echo "Path-ul nu a fost setat!" | tee -a "$path_log"
    else
        echo "Path-ul setat: $path_stergere" | tee -a "$path_log"
    fi
    
    echo "Doresti sa il setezi/modifici? (y/n)"
    read raspuns
    case "$raspuns" in
        y)  
            read -p "Te rog sa introduci calea directorului cu care vrei sa lucrezi: " path_stergere
            if [ ! -d "$path_stergere" ]; then
                echo "Nu ai introdus o cale spre un director!" | tee -a "$path_log"
                path_stergere=""
            else
                echo "Calea a fost setata!" | tee -a "$path_log"
            fi

            sleep 1.5
            configurare_path_stergere
            ;;
        n)
            meniu_configurare
            ;;
        *)
            echo "Raspuns invalid!" | tee -a "$path_log"
            configurare_path_stergere
            ;;
    esac
}

configurare_terminatie_redenumire() {
    clear

    if [ -z "$terminatie_redenumire" ]; then
        echo "Terminatia nu a fost setat!" | tee -a "$path_log"
    else
        echo "Terminatia setata: $terminatie_redenumire" | tee -a "$path_log"
    fi
    
    echo "Doresti sa o setezi/modifici? (y/n)"
    read raspuns
    case "$raspuns" in
        y)  
            read -p "Te rog sa introduci terminatia cu care vrei sa lucrezi: " terminatie_redenumire
            if [ -z "$terminatie_redenumire" ]; then
                echo "Nu ai introdus o terminatie!" | tee -a "$path_log"
            else
                echo "Terinatia a fost setata!" | tee -a "$path_log"
            fi

            sleep 1
            configurare_terminatie_redenumire
            ;;
        n)
            meniu_configurare
            ;;
        *)
            echo "Raspuns invalid!" | tee -a "$path_log"
            configurare_terminatie_redenumire
            ;;
    esac
}

configurare_linie_editare_continut() {
    clear

    if [ -z "$linie_editare_continut" ]; then
        echo "Linia nu a fost setata!" | tee -a "$path_log"
    else
        echo "Linia setata: $linie_editare_continut" | tee -a "$path_log"
    fi
    
    echo "Doresti sa o setezi/modifici? (y/n)"
    read raspuns
    case "$raspuns" in
        y)  
            read -p "Te rog sa introduci linia cu care vrei sa lucrezi: " linie_editare_continut
            if [ -z "$linie_editare_continut" ]; then
                echo "Nu ai introdus o linie!" | tee -a "$path_log"
            else
                echo "Linia a fost setata!" | tee -a "$path_log"
            fi

            sleep 1
            configurare_linie_editare_continut
            ;;
        n)
            meniu_configurare
            ;;
        *)
            echo "Raspuns invalid!" | tee -a "$path_log"
            configurare_linie_editare_continut
            ;;
    esac
}

configurare_git_repo() {
    clear

    if [ -z "$git_repo" ]; then
        echo "Git repository-ul nu a fost setat!" | tee -a "$path_log"
    else
        echo "Git repository-ul setat: $git_repo" | tee -a "$path_log"
    fi
    
    echo "Doresti sa il setezi/modifici? (y/n)"
    read raspuns
    case "$raspuns" in
        y)  
            read -p "Te rog sa introduci git repository-ul cu care vrei sa lucrezi: " git_repo
            if [ -z "$git_repo" ]; then
                echo "Nu ai introdus un git repository!" | tee -a "$path_log"
            else
                echo "Git repository-ul a fost setat!" | tee -a "$path_log"
            fi

            sleep 1.5
            configurare_git_repo
            ;;
        n)
            meniu_configurare
            ;;
        *)
            echo "Raspuns invalid!" | tee -a "$path_log"
            configurare_git_repo
            ;;
    esac
}

meniu_configurare() {
    clear

    optiuni=("calea pentru stergere"
         "terminatie pentru redenumire"
         "linie pentru editare continut"
         "git repository"
         "iesire")

    PS3="Alege o optiune: "
    echo -e "                     [CONFIGURARE]\n"
    while true; do
        select optiune in "${optiuni[@]}"; do
            case "$optiune" in
                "calea pentru stergere")
                    configurare_path_stergere
                    break
                    ;;
                "terminatie pentru redenumire")
                    configurare_terminatie_redenumire
                    break
                    ;;
                "linie pentru editare continut")
                    configurare_linie_editare_continut
                    break
                    ;;
                "git repository")
                    configurare_git_repo
                    break
                    ;;
                "iesire")
                    meniu_principal        
                    ;;
                *)
                    echo "Invalid option!" | tee -a "$path_log"
                    break
                    ;;
            esac
        done
    done
}

#-------------------------------END CONFIGURARE-------------------------------#

#--------------------------START GASIRE FISIERE VECHI-------------------------#

fisiere_vechi_gasite=""

meniu_gasire_fisiere_vechi() {
    clear

    echo -e "                     [GASIRE FISIERE VECHI]\n"
    if [ ! -z "$fisiere_vechi_gasite" ]; then
        echo "Au fost gasite fisiere mai vechi de $data_finala!"
        select optiune in "vizualizare fisiere" "cauta alte fisiere" "iesire"; do
            case $optiune in
                "vizualizare fisiere")
                    echo "$fisiere_vechi_gasite" && echo "Fisierele au fost vizualizate!" | tee -a "$path_log"
                    read -p "Apasa enter pentru a continua..." temp
                    meniu_gasire_fisiere_vechi
                    ;;
                "cauta alte fisiere")
                    fisiere_vechi_gasite=""
                    meniu_gasire_fisiere_vechi
                    ;;
                "iesire")
                    meniu_principal
                    ;;
            esac
        done
    fi


    echo "Doresti sa lucrezi cu fisierele din directorul curent? (y/n)"
    read raspuns

    case "$raspuns" in
    y)  
        director="."
        ;;
    n)
        read -p "Te rog sa introduci calea directorului: " director
        ;;
    *)
        echo "Raspuns invalid!" | tee -a "$path_log"
        meniu_gasire_fisiere_vechi
        clear
        ;;
    esac

    clear
    if [ ! -d "$director" ]; then
        echo "Nu ai introdus un director!" | tee -a "$path_log"
        sleep 2
        meniu_principal
    else
        gasirea_fisierelor
    fi
}


extragere_informatii_numar() {
    numar=$(echo "$data_selectata" | awk -F '[a-zA-Z]+' '{ print $1 }')
    lungime_numar=$(echo -n $numar | wc -c)
}

gasirea_fisierelor() {

    # Stabilirea datei
    # format acceptat: DD-MM-YYYY
    #                  'x' zile/saptamani/luni/ani
    read -p "Te rog sa introduci data (YYYY-MM-DD  sau  'x' zile/saptamani/luni/ani):" data_selectata

    # verificari luna cu 28 de zile
    if [[ "$data_selectata" =~ ^([0-9]{4})-([1-9]|0[1-9]|1[0-2])-([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1]) ]]; then
        data_finala=$(echo "$data_selectata" | sed -E 's/(\b[0-9]\b)/0\1/g')
    elif [[ "$data_selectata" =~ ^([0-9]+)( |)((zi|zI|Zi|ZI|sa|sA|Sa|SA|lu|lU|Lu|LU|an|aN|An|AN)([a-zA-Z]*))$ ]]; then
        extragere_informatii_numar
        unitate_de_masura=${data_selectata:lungime_numar:2}
        case $unitate_de_masura in
            zi|zI|Zi|ZI)
                data_finala=$(date -d "$numar days ago" +"%Y-%m-%d")
                ;;

            sa|sA|Sa|SA)
                data_finala=$(date -d "$numar weeks ago" +"%Y-%m-%d")
                ;;

            lu|lU|Lu|LU)
                data_finala=$(date -d "$numar months ago" +"%Y-%m-%d")
                ;;

            an|aN|An|AN)
                data_finala=$(date -d "$numar years ago" +"%Y-%m-%d")
                ;;

            *)
                echo "EROARE" | tee -a "$path_log"
                break
                ;;
        esac
    else
        data_finala="stop"
        echo "Nu ai utilizat un format valid pentru data calendaristica!" | tee -a "$path_log"
    fi

    if [ ! "$data_finala" = "stop" ]; then
        echo "Data finala: $data_finala" | tee -a "$path_log"
        fisiere_vechi_gasite=$(find "$director" ! -newermt "$data_finala")
    fi

    clear
    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Nu au fost gasite fisiere mai vechi de $data_finala!" | tee -a "$path_log"
    else
        echo "Au fost gasite fisiere mai vechi de $data_finala!" | tee -a "$path_log"
    fi
    sleep 1.5
    meniu_principal
}

#---------------------------END GASIRE FISIERE VECHI--------------------------#

#--------------------------------START MUTARE---------------------------------#

meniu_mutare() {
    clear

    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Foloseste operatie de gasire a fisierelor mai vechi de o data calendaristica!" | tee -a "$path_log"
        sleep 3
        meniu_principal    
    fi

    echo -e "            [MUTARE]\n"
    PS3="Alege o optiune: "
    while true; do
        select optiune in local cloud iesire; do
            case $optiune in
                "local")
                    mutare_fisiere_local
                    break                
                    ;;
                "cloud")
                    mutare_fisiere_cloud
                    break
                    ;;
                "iesire")
                    meniu_principal
                    ;;
            esac    
        done
    done
}

mutare_fisiere_local() {
    director_b=""
    while [ -z "$director_b" ]; do
        read -p "Te rog sa introduci calea directorului in care vrei sa muti: " director_b             
    done
    if [ ! -d "$director_b" ]; then
        clear
        echo "Nu ai introdus o cale valida!" | tee -a "$path_log"
        sleep 1.5
        meniu_mutare             
    else
        for fisier in $fisiere_vechi_gasite; do
            mv "$fisier" "$director_b" 2>/dev/null
        done
        clear
        echo "Fisierele au fost mutate!" | tee -a "$path_log"
        sleep 1.5
    fi
}

mutare_fisiere_cloud() {
    if [ -z "$git_repo" ]; then
        clear
        echo "GIT repository-ul nu a fost configurat!" | tee -a "$path_log"
        sleep 2
        meniu_principal    
    fi

    rm -rf temp_git_repository
    if git clone "$git_repo" temp_git_repository; then
        for fisier in $fisiere_vechi_gasite; do
            cp -r "$fisier" temp_git_repository/
        done
        cd temp_git_repository

        if git add . && git commit -m "backup" && git push; then
            echo "Fisierele au fost mutate in cloud cu succes!" | tee -a "$path_log"    
            cd ..
        else
            echo "Mutarea fisierelor a esuat!" | tee -a "$path_log"
        fi
    else
        echo "Clonarea repo-ului a esuat!" | tee -a "$path_log"
    fi
    rm -rf temp_git_repository

    sleep 2
    meniu_mutare
}

#---------------------------------END MUTRARE---------------------------------#
#-------------------------------START STERGERE---------------------------------#

meniu_stergere() {
    clear

    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Foloseste operatie de gasire a fisierelor mai vechi de o data calendaristica!" | tee -a "$path_log"
        sleep 3
        meniu_principal    
    fi
    
    echo -e "                 [STERGERE]\n"
    PS3="Alege o optiune: "
    while true; do
        select optiune in "Stergere manuala" "Stergere periodica" "Iesire"; do
            case $optiune in
                "Stergere manuala")
                    stergere_manuala
                    break
                    ;;
                "Stergere periodica")
                    stergere_periodica
                    break
                    ;;
                "Iesire")
                    meniu_principal
                    ;;
                *)
                    echo "Optiune invalida!" | tee -a "$path_log"
                    break
                    ;;
            esac
        done
    done
}

stergere_manuala() {
    if [ ! -z "$fisiere_vechi_gasite" ]; then
        for fisier in $fisiere_vechi_gasite; do
            if [ -f "$fisier" ]; then
                rm "$fisier" 2>/dev/null
            fi
        done
    fi
    echo "Fisierele au fost sterse!" | tee -a "$path_log"
}

stergere_periodica() {
    cron_entry="0 20 * * 1 find $fisiere_vechi_gasite -type f -mtime +60 -exec rm {} \;"
    cron_jobs=$(crontab -l)
    echo "$cron_jobs"

    if echo "$cron_jobs" | grep -q "$cron_entry"; then
        echo "Cron job-ul exista deja!" | tee -a "$path_log" 
    else
        (crontab -l 2>/dev/null; echo "$cron_entry") | crontab -
        echo "Stergerea periodica a fost programata: Fisierele mai vechi de 60 de zile vor fi sterse in fiecare luni la ora 20" | tee -a "$path_log"
    fi
}

#--------------------------------END STERGERE---------------------------------#

#------------------------------START REDENUMIRE-------------------------------#

meniu_redenumire() {
    clear

    echo -e "                    [REDENUMIRE]\n"
    PS3="Alege o optiune: "
    while true; do
        select optiune in renaming iesire; do
            case $optiune in
                "renaming")
                    redenumire_fisiere
                    break
                    ;;
                "iesire")
                    meniu_principal
                    ;;
                *)
                    echo "Optiune invalida!" | tee -a "$path_log"
                    break
                    ;;
            esac    
        done
    done
}

redenumire_fisiere() {

    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Foloseste operatie de gasire a fisierelor mai vechi de o data calendaristica!" | tee -a "$path_log"
        sleep 3
        meniu_principal    
    else
        sufix=""
        while [ -z "$sufix" ]; do
            read -p "Te rog sa introduci sufixul pe care vrei sa-l adaugi la fisiere (ex: old): " sufix
        done

        for file in $fisiere_vechi_gasite; do
            echo "file: $file"
            if [ -f "$file" ]; then
                elimin_extensie=$(echo "$file" | awk -F '.' '{print $1}')
                nume_nou="$elimin_extensie.$sufix"
                mv "$file" "$nume_nou"
            fi
        done
        clear
        echo "Redenumirea a fost finalizata!" | tee -a "$path_log"
        sleep 1.5
    fi
}


#-------------------------------END REDENUMIRE--------------------------------#

#-------------------------------START EDITARE---------------------------------#

operatii_pentru_anumite_fisiere() {
    case $1 in
        "suprascriere")
            for fisier in ${lista_fisiere_selectate[*]}; do
                echo "$linie_editare_continut" > "$fisier"
            done
            ;;
        "adaugare_linie_final")
            for fisier in ${lista_fisiere_selectate[*]}; do
                echo "$linie_editare_continut" >> "$fisier" 
            done
            ;;
        "stergere_text")
            for fisier in ${lista_fisiere_selectate[*]}; do
                sed -i "/$linie_editare_continut/d" "$fisier" 
            done
            ;;
        "inlocuire_text")
            for fisier in ${lista_fisiere_selectate[*]}; do
                sed -i "s/$linie_editare_continut/$text_inlocuitor/g" "$fisier"
            done
            meniu_editare  
            ;;
    esac
}

operatii_pentru_toate_fisierele() {
    case $1 in
        "suprascriere")
            for fisier in $fisiere_vechi_gasite; do
                if [ -f "$fisier" ]; then
                    echo "$linie_editare_continut" > "$fisier" 
                fi
            done
            meniu_editare
            ;;
        "adaugare_linie_final")
            for fisier in $fisiere_vechi_gasite; do
                if [ -f "$fisier" ]; then
                    echo "$linie_editare_continut" >> "$fisier" 
                fi
            done
            meniu_editare
            ;;
        "stergere_text")
            for fisier in $fisiere_vechi_gasite; do
                if [ -f "$fisier" ]; then
                  sed -i "/$linie_editare_continut/d" "$fisier"
                fi
            done
            meniu_editare  
            ;;
        "inlocuire_text")
            for fisier in $fisiere_vechi_gasite; do
                if [ -f "$fisier" ]; then
                    sed -i "s/$linie_editare_continut/$text_inlocuitor/g" "$fisier"
                fi
            done
            meniu_editare  
            ;;
    esac
}

selectie_lista_fisiere() {
    clear

    PS3="Alege o optiune: "
    lista_fisiere_selectate=()
    while true; do
        select fisier in $fisiere_vechi_gasite "undo" "confirma" "renunta"; do
            if [ "$fisier" != "undo" ] && [ "$fisier" != "confirma" ] && [ "$fisier" != "renunta" ] && [ -f "$fisier" ]; then
                lista_fisiere_selectate+=("$fisier")
                clear
                echo "Ai selectat fișierele: ${lista_fisiere_selectate[*]}" && echo "Ai selectat anumite fisier pentru o operatie!" | tee -a "$path_log"
            fi
            case $fisier in
                "undo")
                    if [ ${#lista_fisiere_selectate[@]} -gt 0 ]; then
                        unset lista_fisiere_selectate[$((${#lista_fisiere_selectate[@]} - 1))]
                    else
                        echo "Nu există fișiere în listă pentru a fi eliminate!" | tee -a "$path_log"
                    fi
                    clear
                    echo "Ai selectat fișierele: ${lista_fisiere_selectate[*]}"; echo ""
                    break
                    ;;
                "confirma")
                    operatii_pentru_anumite_fisiere $1
                    meniu_editare
                    break
                    ;;                
                "renunta")
                    lista_fisiere_selectate=""
                    alegere_fisiere
                    break
                    ;;
                *)
                    echo ""
                    break
                    ;;        
            esac    
        done
    done
}

alegere_fisiere() {
    clear

    optiuni=("pentru toate fisierele"
             "pentru anumite fisiere"
             "renunta")
    echo "Linia setata: $linie_editare_continut"
    while true; do
        select optiune in "${optiuni[@]}"; do      
            case $optiune in
                "${optiuni[0]}")
                    operatii_pentru_toate_fisierele $1
                    break
                    ;;
                "${optiuni[1]}")
                    selectie_lista_fisiere $1   
                    break
                    ;;
                "${optiuni[2]}")
                    meniu_editare
                    break
                    ;;
                *)
                    echo ""
                    break
                    ;;
            esac  
        done
    done
}

meniu_editare() {
    clear

    if [ -z "$linie_editare_continut" ]; then
        echo "Linia de editare nu a fost configurata!" | tee -a "$path_log"
        sleep 3
        meniu_principal
    fi

    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Foloseste operatie de gasire a fisierelor mai vechi de o data calendaristica!" | tee -a "$path_log"
        sleep 3
        meniu_principal
    fi

    echo -e "                  [EDITARE]\n"
    PS3="Alege o optiune: "
    optiuni=("suprascriere"
             "adauga o linie la final de fisier"
             "stergere text"
             "inlocuire text"
             "iesire")
    echo "Linie setata: $linie_editare_continut"
    select optiune in "${optiuni[@]}"; do
        case $optiune in
            "suprascriere")
                alegere_fisiere suprascriere 
                break
                ;;
            "adauga o linie la final de fisier")
                alegere_fisiere adaugare_linie_final
                ;;
            "stergere text")
                alegere_fisiere stergere_text
                ;;
            "inlocuire text")
                text_inlocuitor=""
                while [ -z "$text_inlocuitor" ]; do
                    read -p "Te rog sa introduci cu ce vrei sa inlocuiesti liniile: " text_inlocuitor                
                done
                alegere_fisiere inlocuire_text
                ;;
            "iesire")
                meniu_principal
                ;;
            *)
                echo "Optiune invalida!" | tee -a "$path_log"
                break
                ;;
        esac
    done
}

#---------------------------------END EDITARE---------------------------------#

#--------------------------------START ARHIVARE-------------------------------#

arhivare_fisiere() {
    for fisier in $fisiere_vechi_gasite; do
        if [ -d "$fisier" ]; then
            tar -czf "$fisier.tar.gz" -C "$fisier" .
        fi
    done
}

meniu_arhivare() {
    clear

    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Foloseste operatie de gasire a fisierelor mai vechi de o data calendaristica!" | tee -a "$path_log"
        sleep 3
        meniu_principal
    fi

    echo -e "                  [ARHIVARE]\n"
    while true; do
        select optiune in arhivare iesire; do
            case $optiune in
                "arhivare")
                    arhivare_fisiere
                    break
                    ;;
                "iesire")
                    meniu_principal
                    ;;
                *)
                    clear
                    break
                    ;;
            esac    
        done
    done
}


#--------------------------------END ARHIVARE---------------------------------#

#-------------------------------START CAUTARE---------------------------------#

cautare_in_fisier() {
    cautare=""
    while [ -z "$cautare" ]; do
        read -p "Te rog sa introduci expresia de cautare: " cautare
    done

    expresie_gasita=0
    echo "Expresia a fost gasita in: "
    for fisier in $fisiere_vechi_gasite; do
        if [ -f "$fisier" ]; then
            if grep -q "$cautare" "$fisier"; then
                echo "$fisier"
                expresie_gasita=1
            fi
        fi
    done
    if [ "$expresie_gasita" -eq 0 ]; then
        echo "Expresia nu a fost gasita!" | tee -a "$path_log"
    fi
    echo "S-a cautat in fisier expresia $cautare!" | tee -a "$path_log"

    read -p "Apasa enter pentru a continua..." temp
    meniu_principal
}

meniu_cautare() {
    clear

    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Foloseste operatie de gasire a fisierelor mai vechi de o data calendaristica!" | tee -a "$path_log"
        sleep 3
        meniu_principal
    fi

    echo -e "               [CAUTARE]\n"
    while true; do
        select optiune in cautare iesire; do
            case $optiune in
                "cautare")
                    cautare_in_fisier
                    break
                    ;;
                "iesire")
                    meniu_principal
                    ;;
                *)
                    echo "Optiune invalida!" | tee -a "$path_log"
                    break
                    ;;
            esac    
        done
    done
}

#---------------------------------END CAUTARE---------------------------------#

#-------------------------------START CRIPTARE--------------------------------#

criptare_fisiere() {

    # Introducerea parolei pentru criptare
    read -s -p "Te rog sa introduci parola pentru criptare: " parola
    echo

    echo "$fisiere_vechi_gasite" | xargs -I {} gpg --batch --yes --passphrase "$parola" -c "{}" > /dev/null 2>&1
}

meniu_criptare() {
    clear

    if [ -z "$fisiere_vechi_gasite" ]; then
        echo "Foloseste operatie de gasire a fisierelor mai vechi de o data calendaristica!" | tee -a "$path_log"
        sleep 3
        meniu_principal
    fi

    echo -e "               [CRIPTARE]\n"
    while true; do
        select optiune in criptare iesire; do
            case $optiune in
                "criptare")
                    criptare_fisiere
                    break
                    ;;
                "iesire")
                    meniu_principal
                    ;;
                *)
                    echo "Optiune invalida!" | tee -a "$path_log"
                    break
                    ;;
            esac    
        done
    done
}

#--------------------------------END CRIPTARE---------------------------------#

#---------------------------------START MENIU---------------------------------#

meniu_principal() {
    clear

    operatii=("configurare"
              "gasire fisiere vechi"
              "mutare fisiere"
              "stergere fisiere"
              "redenumire fisiere"
              "editare continut fisiere"
              "cautare in fisier"
              "criptare fisiere"
              "arhivare directoare"
              "iesire")

    PS3="Alege o operatie: "
    echo -e "               [BACKUP AVANSAT DE FISIERE]\n"
    # Use select to display menu
    select operatie in "${operatii[@]}"; do
        case "$operatie" in
            "configurare")
                meniu_configurare
                ;;
            "gasire fisiere vechi")
                meniu_gasire_fisiere_vechi
                ;;
            "mutare fisiere")
                meniu_mutare
                ;;
            "stergere fisiere")
                meniu_stergere
                ;;
            "redenumire fisiere")
                meniu_redenumire
                ;;
            "editare continut fisiere")
                meniu_editare
                ;;
            "cautare in fisier")
                meniu_cautare
                ;;
            "criptare fisiere")
                meniu_criptare
                ;;
            "arhivare directoare")
                meniu_arhivare
                ;;
            "iesire")
                echo "You selected iesire"
                clear
                exit 0
                ;;
            *)
                echo "Optiune invalida!"
                ;;
        esac
    done
}

meniu_principal
