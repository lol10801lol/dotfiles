
#!/bin/bash
 
## dzen stuff
FG='#CCCCCC'
BG='#333333'
FONT="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
 
function uniq_linebuffered() {
   awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}
 
{
   conky | while read -r; do
      echo -e "conky $REPLY";
     
   done > >(uniq_linebuffered) &
   childpid=$!
   herbstclient --idle
   kill $childpid
} | {
   TAGS=( $(herbstclient tag_status $monitor) )
      conky=""
      separator="^fg(#333333)^ro(1x16)^fg()"
      while true; do
         for i in "${TAGS[@]}"; do
            echo -n "^ca(1,herbstclient use ${i:1}) "
            case ${i:0:1} in
            '#')
               echo -n "^fg(#2290B5)[^fg(#CCCCCC)${i:1}^fg(#2290B5)]"
               ;;
            ':')
               echo -n "^fg(#CCCCCC) ${i:1} "
               ;;
            *)
               echo -n "^fg(#2290B5) ${i:1} "
               ;;
            esac
            echo -n "^ca()"
        done
        echo -n " $separator"
        conky_text_only=$(echo -n "$conky "|sed 's.\^[^(]*([^)]*)..g')
        width=$(textwidth "$FONT" "$conky_text_only  ")
        echo -n "^p(_RIGHT)^p(-$width)$conky"
        echo
        read line || break
        cmd=( $line )
   case "$cmd[0]" in
               tag*)
                  TAGS=( $(herbstclient tag_status $monitor) )
                  ;;
               conky*)
                  conky="${cmd[@]:1}"
                  ;;
               esac
     done
} 2> /dev/null |dzen2 -ta l -y 0 -x 0 -h 16 -w 1920 -fg $FG -bg $BG -fn $FONT &
