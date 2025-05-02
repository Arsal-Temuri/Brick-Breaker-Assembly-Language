includelib winmm.lib
INCLUDE Irvine32.inc

PlaySound PROTO,             ; Declare PlaySound function prototype
    pszSound: PTR BYTE,      ; pszSound: Pointer to sound file or alias
    hmod: DWORD,             ; hmod: Handle to module containing the sound (if applicable)
    fdwSound: DWORD          ; fdwSound: Sound flags (e.g., async, loop, etc.)

BUFFER_SIZE = 501           ; Define the buffer size as 501 bytes


.data

temp1 dd 0                  ; Reserve 4 bytes for temp1, initialized to 0
temp2 dd ?                  ; Reserve 4 bytes for temp2, uninitialized
scrdelay db 1               ; Reserve 1 byte for screen delay, initialized to 1
balldelay db 0              ; Reserve 1 byte for ball delay, initialized to 0

SND_ALIAS    DWORD 00010000h ; Define constant for sound alias flag
SND_RESOURCE DWORD 00040005h ; Define constant for sound resource flag
SND_FILENAME DWORD 00020000h ; Define constant for sound filename flag
SND_ASYNC    DWORD 0001h     ; Define constant for asynchronous sound flag


startsound BYTE "sounds/game_start.wav",0      ;LINK TO .WAV FILES FOR SOUND EFFECTS
balltouch BYTE "sounds/ball_touch.wav",0
keypress BYTE "sounds/press.wav",0
powerPsound byte "sounds/power_pellet.wav",0
lifelost byte "sounds/Died.wav",0
fruit byte "sounds/eat_fruit.wav",0
gameoversound byte "sounds/game_over.wav",0
pausesound byte "sounds/intermission.wav",0
munch BYTE "sounds/Coin Credit.wav",0
lifebonus BYTE "sounds/Extra Life.wav",0
levelup BYTE "sounds/level up.wav",0
gamewin BYTE "sounds/game_win.wav",0

 scorestring db "  ",0
    commaseperator db ",",0
    barseperator db "|", 0
newline db 13, 10, 0

 file_handle HANDLE ?

buffer BYTE BUFFER_SIZE DUP(?)
filename     BYTE  "highscore.txt",0
fileHandle   HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0

strCannotOpen BYTE "Cannot open file", 0dh, 0ah, 0
strErrorReading BYTE "Error reading file. ", 0
strBufferTooSmall BYTE "Error: Buffer too small for the file", 0dh, 0ah, 0
strFileSize BYTE "File size: ", 0
strBuffer BYTE "Buffer:", 0dh, 0ah, 0dh, 0ah, 0

backkey db "Press any key to go back...",0
mapbool db 0

color dw yellow+(magenta*16)

level db 1
levelstr db "LEVEL: ",0

;;set map for each level and their reset versions

LoadingScreen1 BYTE "____________________________________________________________________________________",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                     /\_/\                                      ||",0ah
            BYTE "||                                    ( o.o )                                     ||",0ah
            BYTE "||                                     > ^ <                                      ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                   LOADING....                                  ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                      (Hint: Hit the Ball with your Paddle)                     ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "------------------------------------------------------------------------------------",0

LoadingScreen2 BYTE "____________________________________________________________________________________",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                     /\_/\                                      ||",0ah
            BYTE "||                                    ( o.o )                                     ||",0ah
            BYTE "||                                     > ^ <                                      ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                   LOADING....                                  ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                  (Hint: Some Bricks may take more Hits to Break)               ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "------------------------------------------------------------------------------------",0


LoadingScreen3 BYTE "____________________________________________________________________________________",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                     /\_/\                                      ||",0ah
            BYTE "||                                    ( o.o )                                     ||",0ah
            BYTE "||                                     > ^ <                                      ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                   LOADING....                                  ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                      (Hint: Dont Lose all your Lives :P)                       ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "------------------------------------------------------------------------------------",0


; 96 bricks in this 
MapLevel1  BYTE "____________________________________________________________________________________",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||        ===========              =============              ===========         ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||        ===========              =============              ===========         ||",0ah 
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                              ===================                               ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "------------------------------------------------------------------------------------",0

    mapsize=(sizeof Maplevel1*28)


; 236 bricks in this 
MapLevel2 BYTE "____________________________________________________________________________________",0ah
            BYTE "||        ========================              ==========================        ||",0ah
            BYTE "||                              ===================                               ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                          =============================                         ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||     ============================             =============================     ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "|| ====================================     ===================================== ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "------------------------------------------------------------------------------------",0


; 471 bricks
MapLevel3 BYTE "____________________________________________________________________________________",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||            =====================|     |=====================                   ||",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||================|     ==========================================================||",0ah
            BYTE "||================|     ==========================================================||",0ah
            BYTE "||                |                                                               ||",0ah
            BYTE "||==========================================================     |================||",0ah
            BYTE "||==========================================================     |================||",0ah
            BYTE "||                                                               |                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||===================================   ==========================================||",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||                                 |     |                                        ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "||                                                                                ||",0ah
            BYTE "------------------------------------------------------------------------------------",0



index dw 0

ground1 BYTE "||",0ah,0
ground2 BYTE "||",0ah,0


;;PAGES
titlepage byte 0ah, 0ah, 0ah
byte "                                              _    _    _    _    _                                   ", 0ah
byte "                                             / \ // \ // \ // \ // \                                    ", 0ah
byte "                                            ( B |  R |  I |  C |  K )                                       ", 0ah
byte "                                             \_/\\__/\\__/\\__/\\__/                                          ", 0ah
byte "                                          _    _    _    _    _    _    _                                  ", 0ah
byte "                                         / \ // \ // \ // \ // \ // \ // \                              ", 0ah
byte "                                        ( B |  R |  E |  A |  K |  E |  R )                                ", 0ah
byte "                                         \_/\\__/\\__/\\__/\\__/\\__/\\__/                                 ", 0ah
byte "                                                                                                          ", 0ah
byte "                                                                                                        ", 0ah, 0ah, 0ah
byte "                                                       _    _                                         ", 0ah
byte "                                                      / \  / \                                        ", 0ah
byte "                                                     ( B |  Y )                                       ", 0ah
byte "                                                      \_/  \_/                                        ", 0ah

byte "                              _    _    _    _    _     _     _    _    _    _    _    _              ", 0ah
byte "                             / \ // \ // \ // \ // \   / \   / \ // \ // \ // \ // \ // \             ", 0ah
byte "                            ( A |  R |  S |  A |  L | ( ~ ) | M |  A |  R |  Y |  A |  M )            ", 0ah
byte "                             \_/ \__/ \__/ \__/ \\_/   \_/   \_/ \__/ \__/ \__/ \__/ \__/             ", 0ah
byte "                                                                                                      ", 0ah
byte "                                                                                                      ", 0ah
byte "                                             Press Any Key to start                     ", 0




nameEnter byte 0ah,0ah,0ah
        byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah ,0ah
          byte "                                                   Enter Your Name: ",0ah
          byte "                                                           ",0


menustr1 byte 0ah,0ah,0ah
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  ,0ah
          byte "                                                   -> Start",0ah
          byte "                                                      Instructions",0ah
          byte "                                                      Highscores",0

menustr2 byte 0ah,0ah,0ah
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  ,0ah
          byte "                                                      Start",0ah
          byte "                                                   -> Instructions",0ah
          byte "                                                      Highscores",0

menustr3 byte 0ah,0ah,0ah
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  ,0ah
          byte "                                                      Start",0ah
          byte "                                                      Instructions",0ah
          byte "                                                   -> Highscores",0



gameOverStr1 byte "                                                                                                      ",0ah 
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  ,0ah
          byte "                                         G  A  M  E   O  V  E  R",0ah
          BYTE "                                            ->Go back to start",0ah
          byte "                                              close game",0ah,0

gameOverStr2 byte "                                                                                                      ",0ah 
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah ,0ah
          byte "                                         G  A  M  E   O  V  E  R",0ah
          BYTE "                                              Go back to start",0ah
          byte "                                            ->close game",0ah,0


PauseStr1 byte "                                                                                                  ",0ah
         byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  ,0ah
          byte "                                             P  A  U  S  E  D",0ah
          BYTE "                                               ->Resume",0ah
          BYTE "                                             Go back to menu ",0ah
          byte "                                                                    ",0ah,0


PauseStr2 byte "                                                                                                  ",0ah
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  ,0ah
          byte "                                             P  A  U  S  E  D",0ah
          BYTE "                                                 Resume",0ah
          BYTE "                                           ->Go back to menu ",0ah
          byte "                                                                    ",0ah,0


WinnerStr byte 0ah,0ah,0ah
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                          ",0ah  
          byte "                                                                                                            ",0ah  
          byte "                                                                                                         ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                           _    _    _    _    _                                         ",0ah    
          byte "                                          / \ // \ // \ // \ // \                                        ",0ah
          byte "                                         ( B |  R |  I |  C |  K )                                      ",0ah
          byte "                                          \_/\\__/\\__/\\__/\\__/                                     ",0ah,0ah,0ah

          byte "                                      _    _    _    _    _    _    _                                 ",0ah  
          byte "                                     / \ // \ // \ // \ // \ // \ // \                                ",0ah  
          byte "                                    ( B |  R |  E |  A |  K |  E |  R )                               ",0ah  
          byte "                                     \_/\\__/\\__/\\__/\\__/\\__/\\__/                                ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  
          byte "                                                                                                      ",0ah  ,0ah
          byte "                                            FINAL SCORE: ",0ah,0ah
          byte "                                           Y  O  U     W  O  N",0ah,0ah
          BYTE "                                           press 1 to go back to start",0ah
          byte "                                           press x to close game",0ah,0




instructionPage byte "                                          ",0ah
                byte "                                                I N S T R U C T I O N S",0ah,0ah
                byte "                                                   Short and Simple:",0ah
                byte "                              1. Your goal is to clear each Level by DESTROYING ALL BRICKS ",0ah
                byte "                                                2. You have 3 Lives",0ah
                byte "                                             3. Hit the Ball with the Paddle",0ah
                byte "                                         4. If You lose all lives, game is over!",0ah,0ah
                byte "                                                       Controls:",0ah
                byte "                                              1. Press 'A' to move left",0ah
                byte "                                              2. Press 'D' to move Right",0ah
                byte "                                              3. Press 'S' to Stop Moving",0ah
                byte "                                              4. Press 'P' to Pause",0ah
                byte "                                              4. Press 'X' to exit",0ah
                byte "                                              5. Press 'L' to reset lives",0ah,0ah
                byte "                                                     Extra Life '+':",0ah
                byte "                       This treat is hidden in the third level, Find a way to it and save your skin!",0ah,0ah
                byte "                                            ",0ah
                byte "                                                         /\_/\     ",0ah
                byte "                                                        ( o.o )   ",0ah
                byte "                                                         > ^ <   ",0ah
                byte "                                                  He will be watching             ",0ah
                byte "                                              ",0ah,0ah
                byte "                                                                                     Press any Key to go back ",0ah,0ah
                byte "                                          ",0




;GAME FUNCTIONALITY VALUES

name1 byte 50 dup(0)              ; Declare a string of 50 bytes for storing name

strScore BYTE "SCORE: ",0         ; Label for displaying the score text
score Word 0                     ; Variable to store the score (initialized to 0)

strLives BYTE "LIVES: ",0         ; Label for displaying the lives text
life5 byte "<3 <3 <3 <3 <3",0    
life4 byte "<3 <3 <3 <3   ",0   
life3 byte "<3 <3 <3      ",0 
life2 byte "<3 <3         ",0    
life1 byte "<3            ",0  
lives db 3                       ; Initialize number of lives to 3

xPos sBYTE 40                    ; x-position of player (signed byte)
yPos sBYTE 27                    ; y-position of player (signed byte)

speed db 0                       ; Speed of player or ball (initialized to 0)

inputChar BYTE ?                  ; Variable to store user input character

DirX sbyte 0                      ; Direction of movement along x-axis (signed byte)
DirY sbyte 0                      ; Direction of movement along y-axis (signed byte)

ballxPos sbyte 41,42,40,39       ; Initial x-positions for the ball (4 values)
ballYpos sbyte 12,13,12,13       ; Initial y-positions for the ball (4 values)

ballDirX sbyte 0,0,-1,1          ; Ball's movement direction along x-axis (4 values)
ballDirY sbyte -1,1,0,0         ; Ball's movement direction along y-axis (4 values)

ballpath byte 10,5,8,15          ; Ball's path values (4 different points)

ballindex dword 0                ; Index for selecting current ball position (dword)

ballspeed byte 0                 ; Ball's speed (initialized to 0)

ballevel dword 1,2,4             ; Different levels for ball behavior (dword)

erase byte "                    ",0 ; String used for erasing screen content (space)

lifePowUp byte 1                 ; Variable for life power-up status (1 byte)

extraLifeX db 0                  ; x-position of extra life (initialized to 0)
extraLifeY db 0                  ; y-position of extra life (initialized to 0)
extraLifeActive db 0             ; Flag to check if extra life is active (0 = inactive)
lifebool db 0                    ; Boolean flag for tracking life status (0 = no extra life)



.code
main PROC
        ; Starting point of the program

    startover:
        ; Display the title screen and clear the screen
        call TitleScreen
        call clrscr

    play:
        ; Check if user wants to restart
        cmp bl, "}"
        je continued
    
        ; Check if lives are 0 (game over condition)
        cmp lives, 0
        je gameover

        ; Jump to main game logic
        jmp j1

    continued:
        ; Reset lives, score, and level
        mov lives, 3
        mov score, 0
        mov level, 1

    j1:
        ; Draw the ground at (2,26) with black color
        mov eax, (black*16)
        call SetTextColor
        call clrscr
    
        ; Set map color to blue
        mov mapbool, 0
        mov eax, blue + (black * 16)
        call SetTextColor
        mov dl, 0
        mov dh, 1
        call Gotoxy

        ; Display map based on the current level
        cmp level, 1
        je FirstlevelMap
        cmp level, 2
        je SecndlevelMap
        cmp level, 3
        je ThrdlevelMap

    FirstlevelMap:
        call loadingscreenfunc
        mov edx, OFFSET MapLevel1  ; Display map for level 1
        call WriteString
        jmp map_printed

    mapy:
        ; Game progress check based on score
        cmp score, 40
        je winy
        cmp score, 15
        je lev3
        cmp score, 6
        je lev2
        jmp gameloop
    
    lev2:
        mov level, 2
        inc score
        jmp secndlevelmap

    lev3:
        mov level, 3
        inc score
        jmp thrdlevelmap

    winy:
        
        jmp winnerscr

    SecndlevelMap:
        ; Set map color to light red and display map for level 2
        mov mapbool, 0
        mov eax, lightred + (black * 16)
        call SetTextColor
        mov dl, 0
        mov dh, 1
        call Gotoxy
        call loadingscreenfunc
        mov edx, OFFSET MapLevel2
        call WriteString
        jmp map_printed

    ThrdlevelMap:
        ; Set map color to yellow and display map for level 3
        mov mapbool, 0
        mov eax, yellow + (black * 16)
        call SetTextColor
        mov dl, 0
        mov dh, 1
        call Gotoxy
        call loadingscreenfunc
        mov edx, OFFSET MapLevel3
        call WriteString
        jmp map_printed

    map_printed:
        ; Call function to draw the player character
        call DrawPlayer

        ; Initialize ball index and level-specific ball logic
        mov ballindex, 0
        mov ecx, 0
        cmp level, 1
        je level1
        cmp level, 2
        je level2
        jmp level3

    level1:
        mov ecx, ballevel[0]
        jmp drawloop

    level2:
        mov ecx, ballevel[0]
        jmp drawloop

    level3:
        mov ecx, ballevel[0]
        jmp drawloop

    drawloop:
        ; Draw the ball and handle ball movement
        call DrawBall
        inc ballindex
        cmp ecx, 0
        je gameloop
        loop drawloop

        ; Delay before the next game loop iteration
        mov eax, 250
        call delay

    gameLoop:
        ; Set game level settings and process movements
        push offset speed
        push offset ballspeed
        call Levelsetting
        pop eax
        mov ballspeed, al
        pop eax
        mov speed, al

        ; Level-specific checks
        cmp level, 1
        je leveloneCheck
        cmp level, 2
        je leveltwoCheck
        cmp level, 3
        je levelthreeCheck

    leveloneCheck:
        mov esi, OFFSET MapLevel1
        jmp checkP

    leveltwoCheck:
        mov esi, OFFSET MapLevel2
        jmp checkP

    levelthreeCheck:
        mov esi, OFFSET MapLevel3
        jmp checkP

    checkP:
        ; Check if player position has changed
        push 0
        pop eax
        cmp eax, 1
        jne no_change
        jmp play

    no_change:
        ; Display score on the screen
        mov eax, white + (black * 16)
        call SetTextColor
        mov dl, 2
        mov dh, 0
        call Gotoxy
        mov edx, OFFSET strScore
        call WriteString
        mov ax, score
        call Writedec

        ; Display lives
        mov dl, 70
        mov dh, 0
        call Gotoxy
        mov edx, OFFSET strLives
        call WriteString
        cmp lives, 5
        je lives5
        cmp lives, 4
        je lives4
        cmp lives, 3
        je lives3
        cmp lives, 2
        je lives2
        cmp lives, 1
        je lives1
        cmp lives, 0
        je gameover

    lives1:
        mov edx, OFFSET life1
        jmp contLives

    lives2:
        mov edx, OFFSET life2
        jmp contLives

    lives3:
        mov edx, OFFSET life3
        jmp contLives

    lives5:
        mov edx, OFFSET life5
        jmp contLives

    lives4:
        mov edx, OFFSET life4

    contLives:
        call WriteString

        ; Display level
        mov dl, 100
        mov dh, 5
        call Gotoxy
        mov edx, OFFSET name1
        call WriteString

        mov dl, 30
        mov dh, 0
        call Gotoxy
        mov eax, 0
        mov edx, OFFSET levelstr
        call WriteString
        mov dl, 40
        mov dh, 0
        call Gotoxy
        mov eax, 0
        mov al, level
        call Writedec

        ; Read keyboard input
        call ReadKey
        jz contd

        ; Check the input and process it
        mov inputChar, al
        INVOKE PlaySound, OFFSET keypress, NULL, 20001H

        ; Exit game if user types 'x'
        cmp inputChar, "x"
        je exitGame

        ; Process movement commands
        cmp inputChar,"l"
        je resetlives
        cmp inputChar, "a"
        je moveLeft
        cmp inputChar, "s"
        je moveStop
        cmp inputChar, "d"
        je moveRight
        cmp inputChar, "p"
        je Pausegame
        
    resetlives:
        mov lives,3
    contd:
        call checkWalls
        mov eax, 0
        mov al, xPos
        push eax
        mov al, yPos
        push eax

        ; Handle power-ups
        call lifePowerUp
        call lifee

        ; Handle player movement and ball-related actions
        call movement
        cmp al, "~"
        je play

        ; Handle ball functions
        mov ballindex, 0
        cmp level, 1
        je lvl1
        cmp level, 2
        je lvl2
        jmp lvl3

    lvl1:
        mov ecx, ballevel[0]
        jmp ballLoop

    lvl2:
        mov ecx, ballevel[0]
        jmp ballLoop

    lvl3:
        mov ecx, ballevel[0]
        jmp ballLoop

    ballLoop:
        call ballmove
        cmp al, "~"
        je play
        call ballcheckwalls
        inc ballindex
        loop ballLoop

        jmp mapy
    jmp gameLoop

    moveLeft:
        ; Change direction to go LEFT
        mov DirX, -2
        mov DirY, 0
        jmp mapy

    moveStop:
        ; Stop movement
        mov DirX, 0
        mov DirY, 0
        jmp mapy

    moveRight:
        ; Change direction to go RIGHT
        mov DirX, 2
        mov DirY, 0
        jmp mapy

    Pausegame:
        ; Handle game pause
        call pauseScreen
        cmp bl, "}"
        je backtomenu

        cmp bl, "{"
        je play

        cmp bl, "+"
        je exitGame

    backtomenu:
        ; Return to the main menu
        call menuScreen
        mov bl, "}"
        jmp play

        ; Display win screen
    winnerscr:
        mov ebx, 0
        push ebx
        call WinnerScreen
        pop ebx
        cmp bl, "}"
        je startover
        jmp exitGame

        ; Display game over screen
    gameover:
        mov ebx, 0
        push ebx
        call gameoverScreen
        pop ebx
        cmp bl, "}"
        je backtomenu

    exitGame:
        ; Exit the program
        exit
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SCREENS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TitleScreen PROC
    ; Set text color for the title screen
    mov eax, dword ptr color
    call settextcolor
    
    ; Display title screen
    mov edx, offset titlepage
    call clrscr
    call writestring
    
    ; Play start sound
    INVOKE PlaySound, OFFSET startsound, NULL, 20001H
    
    mov eax, 0
    
    ; Wait for key press
    call readchar
    
    cmp al, "-"                      ; If "-" pressed, jump to namenter
    jne namenter
    
    ; Play keypress sound and restart TitleScreen
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    mov eax, 0
    call TitleScreen

namenter:
    ; Play keypress sound before name entry
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    mov eax, 0
    
    ; Show name and menu screens
    call nameScreen
    call menuScreen
    
    ret
TitleScreen ENDP


nameScreen PROC
    mov eax, dword ptr color
    call settextcolor
    
    mov edx, offset nameEnter
    call clrscr
    call writestring
    
    ; Read the user input string (name)
    mov edx, offset name1
    mov ecx, sizeof name1
    call readstring
    mov stringlength, eax         ; Store the length of the input string

    ; Play keypress sound
    mov eax, SND_ASYNC
    or eax, SND_FILENAME
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    
    ret
nameScreen ENDP


menuScreen PROC

    menuprinting1:
        ; Set text color and display first menu option
        mov eax, dword ptr color
        call settextcolor
        mov edx, offset menustr1
        call clrscr
        call writestring
        
        call readchar
        cmp al, 0Dh
        je start
        
        INVOKE PlaySound, OFFSET keypress, NULL, 20001H
        jmp menuprinting2

    menuprinting2:
        mov eax, dword ptr color
        call settextcolor
        mov edx, offset menustr2
        call clrscr
        call writestring
        
        ; Wait for key press, enter for instructions
        call readchar
        cmp al, 0Dh
        je instruct
        
        INVOKE PlaySound, OFFSET keypress, NULL, 20001H
        jmp menuprinting3

    menuprinting3:
        mov eax, dword ptr color
        call settextcolor
        mov edx, offset menustr3
        call clrscr
        call writestring
        
        ; Wait for key press, enter to perform option 3 action
        call readchar
        cmp al, 0Dh
        je option3Action
        
        ; Play keypress sound and loop to first menu
        INVOKE PlaySound, OFFSET keypress, NULL, 20001H
        jmp menuprinting1

    instruct:
        INVOKE PlaySound, OFFSET keypress, NULL, 20001H
        call Instructions
        jmp menuprinting1

    option3Action:
        INVOKE PlaySound, OFFSET keypress, NULL, 20001H
        call highscreen
        jmp menuprinting1

    start:
        INVOKE PlaySound, OFFSET keypress, NULL, 20001H
        ret

menuScreen ENDP


highscreen proc
    ; Clear screen and read file
    call clrscr
    call filereading
    
    ; Move cursor to position (100, 50) and display back key prompt
    mov dl, 100
    mov dh, 50
    call gotoxy
    mov edx, offset backkey
    call writestring
    
    ; Wait for user input (space to return)
    call readchar
    cmp al, ' '               ; If space pressed, call highscreen again
    jne return                ; Else, proceed to return

    ; Recursive call if space is pressed
    call highscreen

return:
    ; Play keypress sound and reset registers
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
    ret
highscreen endp


Instructions PROC

    mov eax, dword ptr color
    call settextcolor
    mov edx, offset instructionPage
    call clrscr
    call writestring
    
    ; Wait for user input (space to return)
    call readchar
    cmp al, ' '               ; If space pressed, call Instructions again
    jne return                ; Else, proceed to return

    ; Recursive call if space is pressed
    call Instructions

return:
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
    ret

Instructions ENDP


WinnerScreen PROC
    ; Edit file (if needed)
    call editmyfile

    ; Set up stack frame
    push ebp
    mov ebp, esp

    ; Set text color (yellow on light red) and display winner message
    mov eax, yellow + (magenta * 16)
    call settextcolor
    mov edx, offset WinnerStr
    call clrscr
    call writestring

    ; Display score at position (56, 16)
    mov dl, 58
    mov dh, 23
    call gotoxy
    mov ax, score
    call writeint

    ; Play win sound
    INVOKE PlaySound, OFFSET gamewin, NULL, 20001H
    call readchar

    ; Check user input for next action
    cmp al, "1"           ; If "1", restart game
    je startover

    cmp al, "x"           ; If "x", exit
    je return

startover:
    ; Reset lives and signal to restart
    mov lives, 3
    mov al, "}"
    mov [ebp + 8], al

return:
    ; Play keypress sound and clean up
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    pop ebp
    ret

WinnerScreen ENDP


gameoverScreen PROC
    ; Edit file (if needed)
    call editmyfile

    ; Play "Game Over" sound
    INVOKE PlaySound, OFFSET gameoversound, NULL, 20001H

    ; Set up stack frame
    push ebp
    mov ebp, esp

gameover1:
    ; Display first game over message with blue text
    mov eax, blue + (black * 16)
    call settextcolor
    mov edx, offset gameOverStr1
    call clrscr
    call writestring
    call readchar

    ; Wait for Enter key to proceed
    cmp al, 0Dh
    je startover
    jmp gameover2

gameover2:
    ; Display second game over message with blue text
    mov eax, blue + (black * 16)
    call settextcolor
    mov edx, offset gameOverStr2
    call clrscr
    call writestring
    call readchar

    ; Wait for Enter key to return
    cmp al, 0Dh
    je return
    jmp gameover1

startover:
    ; Reset lives and signal to restart game
    mov lives, 3
    mov al, "}"
    mov [ebp + 8], al

return:
    ; Play keypress sound and clean up
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    pop ebp
    ret

gameoverScreen ENDP


pauseScreen PROC
    ; Play pause sound
    INVOKE PlaySound, OFFSET pausesound, NULL, 20001H

pause1:
    ; Display first pause message with blue text
    mov eax, blue + (black * 16)
    call settextcolor
    mov edx, offset PauseStr1
    call clrscr
    call writestring
    call readchar

    ; Wait for Enter key to go to next message or return to previous screen
    cmp al, 0Dh
    je goback
    jmp pause2

pause2:
    ; Display second pause message with blue text
    mov eax, blue + (black * 16)
    call settextcolor
    mov edx, offset PauseStr2
    call clrscr
    call writestring
    call readchar

    ; Wait for Enter key to go to main menu or return to first message
    cmp al, 0Dh
    je gotomenu
    jmp pause1

    ; SEND VALUES TO MAIN TO NAVIGATE TO SCREENS
gotomenu:
    ; Play keypress sound and signal return to menu
    INVOKE PlaySound, OFFSET keypress, NULL, 20001H
    mov bl, "}"
    ret

goback:
    ; Signal to go back to previous screen
    mov bl, "{"
    ret

gotoend:
    ; Signal to end the game or process
    mov bl, "+"
    ret

pauseScreen ENDP



;;;;;;;;;;;;;;;;;;;;;;SET LEVELS;;;;;;;;;;;;;;;;;

Levelsetting PROC
    push ebp
    mov ebp, esp

    ; Compare level value and jump to corresponding level setup
    cmp level, 1
    je levelONE

    cmp level, 2
    je levelTWO

    cmp level, 3
    je levelTHREE

levelONE:
    ; Set level 1 parameters (100, 100)
    mov eax, 100
    mov ebx, 100
    jmp return

levelTWO:
    ; Set level 2 parameters (80, 50)
    mov eax, 80
    mov ebx, 50
    jmp return

levelTHREE:
    ; Set level 3 parameters (60, 0)
    mov eax, 60
    mov ebx, 0

return:
    ; Store values in memory
    mov [ebp + 12], eax
    mov [ebp + 8], ebx

    pop ebp
    ret
Levelsetting ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLAYER FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawPlayer PROC

    ; Set color to BLACK + LIGHTBLUE to clear previous player position
    mov eax, BLACK + (LIGHTBLUE * 16)    
    call SetTextColor                  ; Apply color
    mov dl, xPos                       ; Set x position
    mov dh, yPos                       ; Set y position
    call Gotoxy                        ; Move cursor to (xPos, yPos)
    mov al, " "                        ; Use space to clear previous player
    call WriteChar                     ; Write space to clear the player

    ; Set color to LightGreen + Black to draw the player
    mov eax, LightGreen + (Black * 16)
    call SetTextColor                  ; Apply player color

    inc xPos                           ; Move player right (increment xPos)
    
    ; Set color to BLACK + LIGHTBLUE again to clear the new position
    mov eax, BLACK + (LIGHTBLUE * 16)    
    call SetTextColor                  ; Apply color for clearing
    mov dl, xPos                       ; Set new x position (after increment)
    mov dh, yPos                       ; Keep y position same
    call Gotoxy                        ; Move to new position
    mov al, " "                        ; Clear previous space
    call WriteChar                     ; Write space to clear the space

    ; Set color to LightGreen + Black for player again
    mov eax, LightGreen + (Black * 16)
    call SetTextColor                  ; Apply player color

    dec xPos                           ; Move player left (decrement xPos)
    dec xPos                           ; Move player left again (decrement xPos twice)

    ; Set color to BLACK + LIGHTBLUE for clearing the space again
    mov eax, BLACK + (LIGHTBLUE * 16)    
    call SetTextColor                  ; Apply color for clearing
    mov dl, xPos                       ; Set new x position (after decrement)
    mov dh, yPos                       ; Keep y position same
    call Gotoxy                        ; Move to new position
    mov al, " "                        ; Clear the space
    call WriteChar                     ; Write space to clear the area

    ; Set color to LightGreen + Black to draw the player again
    mov eax, LightGreen + (Black * 16)
    call SetTextColor                  ; Apply player color

    ret                                 ; Return from the procedure

DrawPlayer ENDP



UpdatePlayer PROC
     ; Clear player's current position

    ; Move to the current position of the player (xPos, yPos)
    mov dl, xPos
    mov dh, yPos
    call Gotoxy                        ; Move the cursor to the current position
    mov al, " "                        ; Clear the player at the current position
    call WriteChar                     ; Write a space to clear

    ; Move player one step to the right and clear that position
    inc xPos                            ; Increment xPos to move player to the right
    mov dl, xPos                        ; Set new x position
    mov dh, yPos                        ; Keep y position the same
    call Gotoxy                         ; Move cursor to new position
    mov al, " "                         ; Clear player at new position
    call WriteChar                      ; Write space to clear

    ; Move player one more step to the right and clear that position
    inc xPos                            ; Increment xPos again to move further right
    mov dl, xPos                        ; Set new x position
    mov dh, yPos                        ; Keep y position same
    call Gotoxy                         ; Move cursor to this new position
    mov al, " "                         ; Clear player at this position
    call WriteChar                      ; Write space to clear

    ; Move player back one step to the left (return to the second position)
    dec xPos                            ; Decrement xPos to move player left
    


    ret                                  ; Return from the procedure

UpdatePlayer ENDP


;----------------MOVEMENTS(AUTO)----------;
movement PROC
        ; AUTOMATIC MOVEMENT FOR PADDLE
        call UpdatePlayer                 ; Update the player's current position
        mov al, DirX                      ; Get the X direction (DirX)
        add al, xPos                      ; Update xPos by adding DirX
        mov xPos, al                      ; Store the new xPos
        mov al, DirY                      ; Get the Y direction (DirY)
        add al, yPos                      ; Update yPos by adding DirY
        mov yPos, al                      ; Store the new yPos
        call DrawPlayer                   ; Draw the player at the new position

        mov ballindex, 0                  ; Reset ball index
        cmp level, 1                      ; Check if level is 1
        je lvl1                           ; Jump to level 1 handling
        cmp level, 2                      ; Check if level is 2
        je lvl2                           ; Jump to level 2 handling
        jmp lvl3                          ; Jump to level 3 handling

    lvl1:
        mov ecx, ballevel[0]              ; Set ball level for level 1
        jmp ballLoop                      ; Jump to ballLoop

    lvl2:
        mov ecx, ballevel[4]              ; Set ball level for level 2
        jmp ballLoop                      ; Jump to ballLoop

    lvl3:
        mov ecx, ballevel[8]              ; Set ball level for level 3
        jmp ballLoop                      ; Jump to ballLoop

    ballLoop:                             ; Loop for handling balls
        cmp al, "~"                       ; Check if a live is lost (specific string)
        je return                         ; If lost, exit the loop

        inc ballindex                     ; Increment the ball index

        loop ballLoop                     ; Continue the loop if not finished

        mov eax, 0                        ; Clear the EAX register
        mov al, xPos                      ; Get xPos
        push eax                          ; Push xPos onto stack
        mov al, yPos                      ; Get yPos
        push eax                          ; Push yPos onto stack

        add esp, 8                        ; Clean up the stack (remove 2 pushed values)

        mov al, speed                     ; Get the current speed
        call delay                        ; Control the movement speed

    return:
        ret                               ; Return from the procedure

movement ENDP


checkWalls PROC
;---------WALL/BOUNDARIES CHECKS------------;

    cmp DirX, 0            ; Check if there is no horizontal movement
    jne carryon            ; If there is movement, continue
    cmp DirY, 0            ; Check if there is no vertical movement
    je return              ; If there is no movement in any direction, return

carryon:
    mov eax, 0             ; Clear EAX register
    mov esi, 0             ; Set up index for map processing
    mov al, yPos           ; Load the current Y position
    dec al                 ; Decrement Y position to check boundaries

    cmp DirY, -1           ; Check if moving up
    je goingU              ; Jump to goingU if moving up

    cmp DirY, 1            ; Check if moving down
    je goingD              ; Jump to goingD if moving down
    jmp go_on              ; Otherwise, continue processing

goingU: 
    dec al                 ; Move up by decreasing Y position
    jmp go_on

goingD:
    inc al                 ; Move down by increasing Y position
    jmp go_on

go_on:
    imul eax, 85           ; Multiply Y position by the map width (85)
    mov ebx, 0             ; Clear EBX register
    mov bl, xPos           ; Load the X position into EBX
    cmp DirX, 1            ; Check if moving right
    jge goingR             ; Jump to goingR if moving right
    cmp DirX, -1           ; Check if moving left
    jbe goingL             ; Jump to goingL if moving left
    jmp go_on1             ; Otherwise, continue processing

goingR:
    inc bl                 ; Move right by increasing X position
    jmp go_on1             ; Continue to process

goingL:
    dec bl                 ; Move left by decreasing X position
    jmp go_on1             ; Continue to process

go_on1:
    add eax, ebx           ; Add X position to the result

    cmp level, 1           ; Check if level is 1
    je Firstlevelmap       ; Jump to level 1 map processing
    cmp level, 2           ; Check if level is 2
    je Secndlevelmap       ; Jump to level 2 map processing
    cmp level, 3           ; Check if level is 3
    je Thirdlevelmap       ; Jump to level 3 map processing

Firstlevelmap:
    mov esi, offset MapLevel1  ; Set map to level 1
    jmp mapdone            ; Jump to map processing done

Secndlevelmap:
    mov esi, offset MapLevel2  ; Set map to level 2
    jmp mapdone            ; Jump to map processing done

Thirdlevelmap:
    mov esi, offset MapLevel3  ; Set map to level 3
    jmp mapdone            ; Jump to map processing done

mapdone:
    ; FIND WALLS and stop movement if a wall is detected
    
    add esi, eax           ; Adjust position based on calculated index
    add esi, 2             ; Move to the correct map position
    mov al, [esi]          ; Load the map value at this position
    cmp al, "|"            ; Check if it's a wall ("|")
    je cont                ; If it's a wall, continue with next check
    inc esi                ; Move to next position
    mov al, [esi]          ; Check the next position
    cmp al, "|"            ; Check if it's a wall ("|")
    je rightwallexception  ; If it's a wall on the right, handle exception
    sub esi, 3             ; Adjust position back
    mov al, [esi]          ; Check the previous position
    cmp al, "|"            ; Check if it's a wall ("|")
    je cont                ; If it's a wall, continue
    dec esi                ; Move back one position
    mov al, [esi]          ; Check the previous position again
    cmp al, "|"            ; Check if it's a wall ("|")
    je leftwallexception   ; If it's a wall on the left, handle exception
    inc esi                ; Move to next position
    jmp return             ; Return from the procedure

leftwallexception:
    mov DirX, -1           ; Set horizontal movement to left
    jmp return             ; Return from the procedure

rightwallexception:
    mov DirX, 1            ; Set horizontal movement to right
    jmp return             ; Return from the procedure

cont:
    inc esi                ; Continue with next position
    mov DirX, 0            ; Stop horizontal movement if hitting a wall
    mov DirY, 0            ; Stop vertical movement if hitting a wall
    jmp return             ; Return from the procedure

return:
    ret                     ; Return from the procedure

checkWalls ENDP


;;;;;;;;;;;;;;;;;;;BALL FUNCTIONS;;;;;;;;;;;;;;;;;;

DrawBall PROC
    
    mov edi, ballindex           ; Load the current ball index into the EDI register

    cmp level, 1                 ; Compare the current level to level 1
    je blinky                    ; If level 1, jump to blinky (red ball)
    cmp level, 2                 ; Compare the current level to level 2
    je pinky                     ; If level 2, jump to pinky (cyan ball)
    cmp level, 3                 ; Compare the current level to level 3
    je inky                      ; If level 3, jump to inky (magenta ball)

blinky:
    mov eax, red                 ; Set ball color to red for blinky
    jmp cont                      ; Jump to continue to draw the ball

pinky:
    mov eax, cyan                ; Set ball color to cyan for pinky
    jmp cont                      ; Jump to continue to draw the ball

inky:
    mov eax, magenta             ; Set ball color to magenta for inky
    jmp cont                      ; Jump to continue to draw the ball

cont:
    call SetTextColor            ; Set the text color using the value in EAX
    mov dl, ballxPos[edi]        ; Load the X position of the ball from the array (ballxPos) using the index in EDI
    mov dh, ballYpos[edi]        ; Load the Y position of the ball from the array (ballYpos) using the index in EDI
    call Gotoxy                  ; Move the cursor to the specified position (dl, dh)
    mov al, "O"                  ; Set the character to be drawn as "O" (the ball)
    call WriteChar               ; Write the "O" character at the cursor position
    ret                           ; Return from the procedure

DrawBall ENDP


ballmove PROC

    cmp balldelay, 0            ; Check if ball delay is zero
    je cont2                    ; If yes, continue
    dec balldelay               ; Otherwise, decrement the delay
    ret

cont2:
    cmp level, 1                ; Check level
    je delaylevel1              ; Level 1: Adjust delay
    cmp level, 2
    je delaylevel2              ; Level 2: Adjust delay
    cmp level, 3
    je nextshi                  ; Level 3: Proceed

delaylevel1:
    add balldelay, 2            ; Increase delay for level 1
    jmp nextshi

delaylevel2:
    add balldelay, 1            ; Increase delay for level 2
    jmp nextshi

nextshi:
    mov edi, 0                  ; Reset ball index
    mov edi, ballindex

    ; Calculate ball's current position in map array
    mov eax, 0
    mov esi, 0
    mov al, ballYpos[edi]
    dec al
    imul eax, 85
    mov ebx, 0
    mov bl, ballxPos[edi]
    add eax, ebx

    ; Select map based on level
    cmp level, 1
    je Firstlevelmap
    cmp level, 2
    je Secndlevelmap
    cmp level, 3
    je Thirdlevelmap

Firstlevelmap:
    mov esi, offset MapLevel1
    jmp mapdone
Secndlevelmap:
    mov esi, offset MapLevel2
    jmp mapdone
Thirdlevelmap:
    mov esi, offset MapLevel3

mapdone:
    add esi, eax
    mov al, [esi]

    ; Determine ball's current position
    cmp al, '.'                 ; Dot (normal ball)
    je on_dot
    cmp al, "*"                 ; Power-up (special ball)
    je onPower
    mov bl, " "                 ; Empty space
    jmp go_ahead

on_dot:
    mov bl, "."
    jmp go_ahead

onPower:
    mov bl, "*"

go_ahead:
    ; Draw the ball
    mov dl, ballxPos[edi]
    mov dh, ballYpos[edi]
    call Gotoxy
    mov eax, blue + (black * 16)
    call SetTextColor
    mov al, bl
    call WriteChar

    ; Move ball and check collisions
    call ballcheckwalls

    ; Update ball position
    mov al, ballDirX[edi]
    add al, ballxPos[edi]
    mov ballxPos[edi], al
    mov al, ballDirY[edi]
    add al, ballYpos[edi]
    mov ballYpos[edi], al

    call DrawBall                ; Redraw the ball
    dec ballpath[edi]            ; Decrease ball path count

    ; Check if ball has fallen below the paddle
    cmp ballYpos[edi], 27
    ja belowPaddle
    cmp ballYpos[edi], 3
    je lala
    mov al, ballspeed
    call delay                  ; Control ball speed

    return:
    ret

lala:
    neg ballDirY[edi]           ; Reverse ball direction
    ret

belowPaddle:
    ; Handle ball falling below the paddle (lose a life)
    mov ebx, ecx
    INVOKE PlaySound, OFFSET lifelost, NULL, 20001H
    mov ecx, ebx
    mov eax, 100
    call delay
    dec lives                    ; Decrease lives
    neg ballDirY[edi]            ; Reverse ball direction

    ret

ballmove ENDP


ballcheckwalls PROC

    mov edi, 0                  ; Reset ball index to 0
    mov edi, ballindex          ; Load ball index from ballindex

    ; Calculate next position in the map array
    mov eax, 0                  ; Clear the eax register
    mov esi, 0                  ; Clear the esi register
    mov al, ballYpos[edi]       ; Load ball's current Y position into al
    dec al                      ; Decrease Y position by 1 to get correct index
    add al, ballDirY[edi]       ; Add Y direction to calculate next Y position
    imul eax, 85                ; Multiply by 85 (map width) to get row offset
    mov ebx, 0                  ; Clear ebx register
    mov bl, ballxPos[edi]       ; Load ball's current X position into bl
    add bl, ballDirX[edi]       ; Add X direction to calculate next X position
    add eax, ebx                ; Add X offset to Y offset to get map index

    ; Select map based on the level
    cmp level, 1                ; Compare level with 1
    je Firstlevelmap            ; Jump to Firstlevelmap if level is 1
    cmp level, 2                ; Compare level with 2
    je Secndlevelmap            ; Jump to Secndlevelmap if level is 2
    cmp level, 3                ; Compare level with 3
    je Thirdlevelmap            ; Jump to Thirdlevelmap if level is 3

Firstlevelmap:
    mov esi, offset MapLevel1  ; Load address of MapLevel1 into esi
    jmp mapdone                ; Jump to mapdone to process the map

Secndlevelmap:
    mov esi, offset MapLevel2  ; Load address of MapLevel2 into esi
    jmp mapdone                ; Jump to mapdone to process the map

Thirdlevelmap:
    mov esi, offset MapLevel3  ; Load address of MapLevel3 into esi

mapdone:
    
    add esi, eax                ; Add the calculated position to the map base address
    mov al, [esi]               ; Load the character at the calculated position into al

    ; Handle collisions with walls, bricks, and paddle
    cmp al, "|"                 ; Compare the character at the current position with a wall
    je bounceX                  ; Jump to bounceX if it's a wall
    cmp al, "="                 ; Compare the character with a brick
    je destroyBrick             ; Jump to destroyBrick if it's a brick
    cmp al, " "                 ; Compare the character with empty space
    je continueMovement         ; Jump to continueMovement if it's empty space

    ; Check for collision with the paddle (assumed to be at line 27)
    cmp ballYpos[edi], 27       ; Compare the ball's Y position with 27 (paddle Y position)
    jne noPaddleCollision       ; Jump to noPaddleCollision if Y is not equal to 27
    mov al, ballxPos[edi]       ; Load ball's X position into al
    cmp al, xPos                ; Compare ball's X position with paddle's X position
    jb noPaddleCollision        ; Jump to noPaddleCollision if ball is before the paddle
    mov ah, xPos
    add ah, 6                   ; Add 6 to xPos to set paddle's end position
    cmp al, ah                  ; Compare ball's X position with paddle's right side
    ja noPaddleCollision        ; Jump to noPaddleCollision if ball is past the paddle

    ; Bounce off the paddle
    mov ebx, ecx
    INVOKE PlaySound, OFFSET balltouch, NULL, 20001H ; Play bounce sound effect
    mov ecx, ebx
    neg ballDirY[edi]           ; Invert the ball's Y direction (bounce off paddle)

    ; Optional: Adjust X direction based on where the ball hits the paddle
    mov al, ballxPos[edi]       ; Load ball's X position into al
    sub al, xPos                ; Subtract xPos to check the relative position on the paddle
    cmp al, 2                   ; Compare the difference with 2 (ball hits the left side of the paddle)
    jbe slightLeft              ; Jump to slightLeft if the ball hits the left side
    cmp al, 4                   ; Compare the difference with 4 (ball hits the right side of the paddle)
    jae slightRight             ; Jump to slightRight if the ball hits the right side
    jmp return                  ; Jump to return if the ball hits the center

slightLeft:
    dec ballDirX[edi]           ; Decrease X direction slightly (move left)
    cmp lifebool, 1             ; Check if the life bool is 1
    je return2                  ; Jump to return2 if lifebool is 1
    jmp return                  ; Otherwise, jump to return

slightRight:
    inc ballDirX[edi]           ; Increase X direction slightly (move right)
    cmp lifebool, 1             ; Check if the life bool is 1
    je return2                  ; Jump to return2 if lifebool is 1
    jmp return                  ; Otherwise, jump to return

continueMovement:
    ; If no collision, continue moving in the current direction
    cmp lifebool, 1             ; Check if lifebool is 1
    je return2                  ; Jump to return2 if lifebool is 1
    jmp return                  ; Otherwise, continue

noPaddleCollision:
    cmp lifebool, 1             ; Check if lifebool is 1
    je return2                  ; Jump to return2 if lifebool is 1
    jmp continueMovement        ; Jump to continueMovement to keep moving

bounceX:
    ; Invert X direction when hitting a vertical wall
    mov ebx, ecx
    INVOKE PlaySound, OFFSET balltouch, NULL, 20001H ; Play bounce sound effect
    mov ecx, ebx
    neg ballDirX[edi]           ; Invert the ball's X direction (bounce off wall)
    cmp lifebool, 1             ; Check if lifebool is 1
    je return2                  ; Jump to return2 if lifebool is 1
    jmp return                  ; Otherwise, jump to return

destroyBrick:
    ; Invert direction and destroy brick
    mov al, " "                 ; Set the character to empty space (remove the brick)
    mov [esi], al               ; Write the empty space back to the map
    mov ebx, ecx
    INVOKE PlaySound, OFFSET balltouch, NULL, 20001H ; Play sound for brick destruction
    mov ecx, ebx
    inc score                    ; Increment the score by 1

    ; Check for extra life condition
    cmp level, 3                ; Compare level with 3 (for level 3 extra life)
    je for3                     ; Jump to for3 if it's level 3

    cmp ballxPos[edi], 41       ; Check if ball is at specific coordinates for extra life
    jne normalBrick             ; Jump to normalBrick if not
    cmp ballYpos[edi], 4        ; Check if ball is at specific coordinates for extra life
    jne normalBrick             ; Jump to normalBrick if not

    cmp lifebool, 1             ; Check if lifebool is 1
    je return2                  ; Jump to return2 if lifebool is 1

    ; Release extra life
    mov extraLifeX, 41          ; Set extra life X position
    mov extraLifeY, 3           ; Set extra life Y position
    mov extraLifeActive, 1      ; Mark extra life as active

for3:
    cmp ballxPos[edi], 16       ; Check if ball is at specific coordinates for level 3 extra life
    jne normalBrick             ; Jump to normalBrick if not
    cmp ballYpos[edi], 3        ; Check if ball is at specific coordinates for level 3 extra life
    jne normalBrick             ; Jump to normalBrick if not

    cmp lifebool, 1             ; Check if lifebool is 1
    je return2                  ; Jump to return2 if lifebool is 1

    ; Release extra life for level 3
    mov extraLifeX, 16          ; Set extra life X position
    mov extraLifeY, 2           ; Set extra life Y position
    mov extraLifeActive, 1      ; Mark extra life as active
     
normalBrick:
    cmp lifebool, 1             ; Check if lifebool is 1
    je return2                  ; Jump to return2 if lifebool is 1
    jmp return                  ; Continue normal execution

return:
    ret                         ; Return from procedure
return2:
    mov extraLifeActive, 0      ; Reset extra life flag
    ret                         ; Return from procedure

ballcheckwalls ENDP



lifePowerUp PROC
    cmp level, 2                  ; Check if the current level is 2
    jne return                    ; If not level 2, skip to return

    cmp extraLifeActive, 1         ; Check if extra life is active
    jne return                    ; If extra life is not active, skip to return

    mov lifebool, 1                ; Activate the extra life by setting lifebool to 1

return:
    cmp extraLifeActive, 0         ; Check if extra life is inactive
    ret                            ; Return from the procedure

lifePowerUp ENDP


lifee PROC
    cmp lifebool, 1
    jne return

    cmp lifePowUp, 0
    jne moveDown

    ; Initialize extra life position if not already active
    ;mov lifePowUp, 1          ; Activate extra life drawing

moveDown:
    ; Move extra life down
     mov dl, extraLifeX
    mov dh, extraLifeY
    call gotoxy
    mov al, " "
    call writechar

    inc extraLifeY
    cmp extraLifeY, 28 ; If reached the bottom boundary
    jae deactivateExtraLife

    ; Draw extra life in new position
    mov eax, green
    call settextcolor
    mov dl, extraLifeX
    mov dh, extraLifeY
    call gotoxy
    mov al, "+"
    call writechar

    ; Set flag to indicate life has been drawn
    mov lifePowUp, 1

    ; Check collision with the paddle
    cmp extraLifeY, 27 
    jne return

    ; Check if extra life is within the paddle's X range
    mov al, extraLifeX
    cmp al, xPos
    jb continueDown
    mov ah, xPos
    add ah, 6 ; Assuming the paddle is 6 units wide
    cmp al, ah
    ja continueDown

    ; Paddle caught the extra life
    inc lives
    jmp deactivateExtraLife

continueDown:
    jmp return

deactivateExtraLife:
    ; Deactivate extra life when it reaches the bottom boundary
    mov lifebool, 0
    mov lifePowUp, 0 ; Ensure the life is not drawn again

return:
    ret

lifee ENDP


loadingscreenfunc PROC

cmp level,1
je loadlevel1
cmp level,2
je loadlevel3
cmp level,3
je loadlevel3
ret

loadlevel1:

mov edx,offset LoadingScreen1
call writestring

mov scrdelay,0

delayload:
call delay
inc scrdelay
cmp scrdelay,150
je loaded
jmp delayload

loadlevel2:

mov edx,offset LoadingScreen2
call writestring

mov scrdelay,0

delayload2:
call delay
inc scrdelay
cmp scrdelay,150
je loaded
jmp delayload2


loadlevel3:

mov edx,offset LoadingScreen3
call writestring

mov scrdelay,0

delayload3:
call delay
inc scrdelay
cmp scrdelay,120
je loaded
jmp delayload3

loaded:
call crlf
call crlf
call crlf
call crlf

ret

loadingscreenfunc ENDP

EditMyFile PROC
    ; Open the file
        push 0                        ; No special access needed
        push FILE_ATTRIBUTE_NORMAL    ; File has normal attributes
        push OPEN_ALWAYS              ; Open file if it exists, create if it doesn't
        push 0                        ; Default value for file creation
        push 0                        ; No security settings
        push FILE_SHARE_WRITE         ; Allow other programs to write to the file
        push offset filename          ; File name to open
        call CreateFileA              ; Call to open the file
        jc endFun                     ; Jump to end if error occurs
        mov file_handle, eax          ; Save the file handle

    ; Move file pointer to the end
        push FILE_END                 ; Move to the end of the file
        push 0                         ; Set movement amount to 0
        push 0                         ; No high-order move
        push file_handle              ; Use the file handle
        call SetFilePointer           ; Call to set the file pointer

    ; Write a newline to the file
        mov edx, OFFSET newline       ; Load newline string address
        mov ecx, 2                    ; Set length of newline (2 characters)
        push 0                         ; Set bytes written to NULL
        push 0                         ; Set overlapped to NULL
        push ecx                       ; Set length of text to write
        push edx                       ; Address of newline
        push file_handle              ; Use the file handle
        call WriteFile                ; Write the newline to the file

    ; Write name1 to the file
        push 0                         ; Set bytes written to NULL
        push 0                         ; Set overlapped to NULL
        push stringlength             ; Length of name1 to write
        push offset name1             ; Address of name1
        push file_handle              ; Use the file handle
        call WriteFile                ; Write name1 to the file

    ; Write a comma separator to the file
        push 0                         ; Set bytes written to NULL
        push 0                         ; Set overlapped to NULL
        push 1                         ; Write one byte (comma)
        push offset commaseperator    ; Address of comma separator
        push file_handle              ; Use the file handle
        call WriteFile                ; Write the comma to the file

    ; Write level to the file
        movzx eax, level              ; Get the level value
        add eax, 48                   ; Convert level to ASCII
        mov esi, OFFSET levelstr      ; Address of level string
        mov [esi], eax                ; Store level as ASCII

        push 0                         ; Set bytes written to NULL
        push 0                         ; Set overlapped to NULL
        push 1                         ; Write one byte (level)
        push offset levelstr          ; Address of level string
        push file_handle              ; Use the file handle
        call WriteFile                ; Write the level to the file

    ; Write another comma separator
        push 0                         ; Set bytes written to NULL
        push 0                         ; Set overlapped to NULL
        push 1                         ; Write one byte (comma)
        push offset commaseperator    ; Address of comma separator
        push file_handle              ; Use the file handle
        call WriteFile                ; Write the comma to the file

    ; Write score to the file
        movzx eax, score              ; Get the score value
        cmp score, 10                 ; Check if score is less than 10
        jl L1                         ; If less, jump to L1
        jge L2                        ; If 10 or more, jump to L2

    L1:                             ; If score is less than 10
        mov esi, OFFSET scorestring  ; Address of score string
        mov eax, 0                   ; Set eax to 0
        add eax, 48                  ; Convert to ASCII
        mov [esi], eax               ; Store in score string
        inc esi                      ; Move to next position
        movzx eax, score             ; Get the score value
        add eax, 48                  ; Convert to ASCII
        mov [esi], eax               ; Store in score string
        jmp L3                        ; Jump to L3

    L2:                             ; If score is 10 or more
        mov esi, OFFSET scorestring  ; Address of score string
        mov bl, 10                   ; Set bl to 10 for division
        div bl                       ; Divide score by 10
        movzx ebx, al                ; Get ones place
        add ebx, 48                  ; Convert to ASCII
        mov [esi], ebx               ; Store ones place
        inc esi                      ; Move to next position
        movzx ebx, ah                ; Get tens place
        add ebx, 48                  ; Convert to ASCII
        mov [esi], ebx               ; Store tens place

    L3:
        push 0                         ; Set bytes written to NULL
        push 0                         ; Set overlapped to NULL
        push 2                         ; Write two bytes (score string)
        push offset scorestring       ; Address of score string
        push file_handle              ; Use the file handle
        call WriteFile                ; Write the score to the file

    ; End of the procedure
    endFun:
    ret
EditMyFile ENDP


filereading PROC

    ; Open the file for input.
    mov edx, OFFSET filename          ; Load filename address
    call OpenInputFile                ; Open file
    mov fileHandle, eax               ; Save file handle

    ; Check for errors.
    cmp eax, INVALID_HANDLE_VALUE     ; Check if file opened successfully
    jne file_ok                       ; Proceed if no error

    ; Error handling
    mov edx, OFFSET strCannotOpen     ; Load error message
    call WriteString                  ; Display error message
    jmp quit                          ; Exit procedure

file_ok:
    ; Read the file into a buffer.
    mov edx, OFFSET buffer            ; Load buffer address
    mov ecx, BUFFER_SIZE             ; Load buffer size
    call ReadFromFile                 ; Read file content
    jnc check_buffer_size            ; Check for read error

    ; Error reading?
    mov edx, OFFSET strErrorReading  ; Load read error message
    call WriteString                  ; Display error message
    call WriteWindowsMsg              ; Show Windows message
    jmp close_file                    ; Close file

check_buffer_size:
    cmp eax, BUFFER_SIZE             ; Check if buffer is large enough
    jb buf_size_ok                   ; Proceed if buffer size is OK

    ; Buffer too small
    mov edx, OFFSET strBufferTooSmall ; Load buffer size error message
    call WriteString                  ; Display message
    jmp quit                          ; Exit procedure

buf_size_ok:
    mov buffer[eax], 0               ; Null-terminate the buffer

    mov edx, OFFSET buffer            ; Load buffer address
    call WriteString                  ; Print buffer content
    call Crlf                         ; Print new line

close_file:
    mov eax, fileHandle               ; Load file handle
    call CloseFile                    ; Close the file

quit:
    ret                               ; Return from procedure

filereading ENDP



END main