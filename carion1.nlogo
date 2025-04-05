breed [ dinosaur a-dinosaur]
breed[a-pachys a-pachy]
breed[a-hadros a-hadro]
breed[a-hypsos a-hypso]
breed[a-ornithos a-ornitho]
breed[a-ankys a-anky]
breed[a-trikes a-trike]
breed[a-sauropods a-sauropod]
turtles-own [ energy found-carion? original-x original-y daily-energy-gain ]
globals [ day data  current-line max-daily-gain]

extensions [csv]



to setup ;
  ca ; clear all
 set day 0 ; sets day to 0

 load-data

   set data but-first csv:from-file "carrion copy.csv" ; brings data in from csv file which contains the food per week to be used in the simulation

   let first-row item day data

 let num-700 item 0 first-row
 let num-2500 item 1 first-row
 let num-75 item 2 first-row
 let num-216 item 3 first-row
 let num-5000 item 4 first-row
 let num-8500 item 5 first-row
 let num-25000 item 6 first-row

ask patches [
   set pcolor brown] ; set patch colour to brown

 create-dinosaur 5 [
   setxy random-xcor random-ycor ; place therapod on a random coordinate when the simulation is reset
set original-x xcor ; store initial x and y coordinates
    set original-y ycor
    set shape "t-rex" ; sets the shape of the turtle to a dinosaur
     set color black
    set size 2 ; size 2x bigger than default turtle size makes it easier to see in the model

    set found-carion? false ; this ensures that the dinosaurs has not found the carrion before the simulation begines
set energy 1500 ; inital energy level so that it can still move around but it has enough energy to start moving, the energy is set as what the mass of the allosaurous is
  set max-daily-gain 125.48 ; gut capacity
    set daily-energy-gain 0

  ]

create-a-pachys num-700 [ set color red ; sets the shape and colour to make it distinct from the dinosaur shape turtles, along with setting the size, and place on the patches
    set shape "cow skull"
    setxy random-xcor random-ycor
    set energy 700
  set size 2 ]

 create-a-hadros num-2500 [set color orange
     set shape "cow skull" ; sets the shape and colour to make it distinct from the dinosaur shape turtles, along with setting the size, and place on the patches
    setxy random-xcor random-ycor
    set energy 2500
   set size 2]

 create-a-hypsos num-75 [ set color blue
     set shape "cow skull" ; sets the shape and colour to make it distinct from the dinosaur shape turtles, along with setting the size, and place on the patches
      setxy random-xcor random-ycor
    set energy 75
   set size 2]

 create-a-ornithos num-216 [ set color white
     set shape "cow skull" ; sets the shape and colour to make it distinct from the dinosaur shape turtles, along with setting the size, and place on the patches
      setxy random-xcor random-ycor
    set energy 216
   set size 2]

 create-a-ankys num-5000 [set color green
       set shape "cow skull" ; sets the shape and colour to make it distinct from the dinosaur shape turtles, along with setting the size, and place on the patches
        setxy random-xcor random-ycor
    set energy 5000
   set size 2]

 create-a-trikes num-8500 [ set color cyan
         set shape "cow skull" ; sets the shape and colour to make it distinct from the dinosaur shape turtles, along with setting the size, and place on the patches
          setxy random-xcor random-ycor
    set energy 8500
   set size 2]

 create-a-sauropods num-25000 [ set color grey
             set shape "cow skull" ; sets the shape and colour to make it distinct from the dinosaur shape turtles, along with setting the size, and place on the patches
            setxy random-xcor random-ycor
    set energy 25000
   set size 2]


  reset-ticks ; sets ticks back to 0

end


to go

 ask dinosaur
 [   ; dinosaur moves around the environment until it detects the carion
    move-dinosaur ; moves the dinosaurs around the environment
     detect-carion ; once it has been detected the therapod moves to the carrion and gains energy from it
     ; need to add command for the therapod to continue to move around the environment and look for more food
 ]

  let current-row item current-line data
  if ticks mod 1440 = 0 [ end-of-day]
;set day (day mod 7  + 1); (week variable needed) sets the week to be 7 days long and then repeats
  if ticks mod 10080 = 0  [next-week]
  if ticks =  525600  [stop] ; stops after 525600 minutes which is how many minutes are in a week



tick

end

to end-of-day
  ask dinosaur [ set max-daily-gain 125.48
    set daily-energy-gain 0 ] ; when the gut capacity is reached the dinosaur can no longer gain energy from the carrion

end


to detect-carion ; lets the therapod detect and  move towards the carrion once it gets within a certain radius

  let all-carrion ( turtles  with [ ; sets all of the breeds of the carrion dinosaurs able to be detected when the allosaurous gets wtihin a certain radius [
    breed = a-pachys or breed = a-hadros or breed = a-hypsos or
    breed = a-ornithos or breed = a-ankys or breed = a-trikes or breed = a-sauropods
  ] )

 let nearby-carion all-carrion in-radius 3.25 ;  detecting within a radius of 3.25 km
   if any? nearby-carion ; if there is nearby carion

  [
    let target one-of nearby-carion ; targets one of the carion
    fd speed ; moves forward 0.002 towards the target which is the km/ min
     face target ; faces the target
    if distance target < detection-range [ set found-carion? true ] ; if the distant to the target is less than one the dinosaur can find the carrion
    set energy energy + 14 ; gain  energy in terms of food needed per day


    ask nearby-carion ; takes energy from the carrion once it meets it
    [ set energy energy - 14
      if energy <= 0 [die] ]

 show ( word "mass: " energy) ; prints what the energy of the dinosaur is after it has moved around its envrionment

  ]
end


to move-dinosaur ; to move the dinosaur around the environment

  fd speed ; moves forward from 3km per hour
  if random 5000 = 0 [ rt 45 ]  ;; Occasional right turn
  if random 5000 = 0 [ lt 45 ]  ;; Occasional left turn ]

  set energy energy - 0.00000000903 ; the energy needed to move aka metabolic cost of movement  calories converted into kg per min burned
 ; if the dinosaurs energy gets to 0 it disappears

end

to decay ; lets carrion decay and lose mass as it sits
  let all-carrion turtles with [
    breed = a-pachys or breed = a-hadros or breed = a-hypsos or
    breed = a-ornithos or breed = a-ankys or breed = a-trikes or breed = a-sauropods
  ]


end


to load-data
 set data but-first csv:from-file "carrion copy.csv" ; pulls data from csv file
end


to next-week ;  commands for each week of the model
  ask turtles with [color != black] [die] ; turtles die at end of day
 set day day + 7 ; sets day to 0
 load-data
  set data filter [ row -> not empty? row] data
if day / 7 >= length data [ show "error day index exceeds"
    stop ]

   let first-row item (day / 7 ) data
  if length first-row < 7 [ show "error first row fewer column"
    stop
  ]
 let num-700 item 0 first-row
 let num-2500 item 1 first-row
 let num-75 item 2 first-row
 let num-216 item 3 first-row
 let num-5000 item 4 first-row
 let num-8500 item 5 first-row
 let num-25000 item 6 first-row

  print ( word "week: " (day / 7 ) )



  create-a-pachys num-700 [ set color red
    set shape "cow skull" ; sets the shape to make it distinct from the dinosaur shape turtles
    setxy random-xcor random-ycor

  set size 2 ]

 create-a-hadros num-2500 [set color orange
     set shape "cow skull" ; sets the shape to make it distinct from the dinosaur shape turtles
    setxy random-xcor random-ycor

   set size 2]

 create-a-hypsos num-75 [ set color blue
     set shape "cow skull" ; sets the shape to make it distinct from the dinosaur shape turtles
      setxy random-xcor random-ycor
   set size 2]

 create-a-ornithos num-216 [ set color white
     set shape "cow skull" ; sets the shape to make it distinct from the dinosaur shape turtles
      setxy random-xcor random-ycor
   set size 2]

 create-a-ankys num-5000 [set color green
       set shape "cow skull" ; sets the shape to make it distinct from the dinosaur shape turtles
        setxy random-xcor random-ycor

   set size 2]

 create-a-trikes num-8500 [ set color cyan
         set shape "cow skull" ; sets the shape to make it distinct from the dinosaur shape turtles
          setxy random-xcor random-ycor

   set size 2]

 create-a-sauropods num-25000 [ set color grey
             set shape "cow skull" ; sets the shape to make it distinct from the dinosaur shape turtles
            setxy random-xcor random-ycor

   set size 2]

end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
928
729
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-35
35
-35
35
0
0
1
ticks
30.0

BUTTON
21
49
87
82
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
93
50
156
83
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
17
101
74
146
NIL
day
17
1
11

SLIDER
24
168
196
201
detection-range
detection-range
2
4.5
3.5
0.1
1
NIL
HORIZONTAL

SLIDER
17
230
189
263
speed
speed
0.001
0.1
0.0049
0.0001
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This is an agent based model used to simulate how theropod dinosaurs potentially could have lived. This model assumes the theropods to be scavengers and has them move around and interact with the carrion or 'food' available to them. 

## HOW IT WORKS

In this model the theropod dinosaur moves around and interacts with its environment around it. It is able to move around the environment randomly and when it comes into contact with one of the carrion agents that is available to it, it is able to move towards it to be able to eat. The detection range and speed are set to be sliders to be able to change to account for different variables. The mass, metabolic rate, gut capacity, and food needed per day are all set to be constants that run within the background as the model is runnimg. The model runs for a simulated year, with each week the carion resets to new food available. 

## HOW TO USE IT

setup: this resets the model back to 0 for it to start from the begining
go: lets the model run for the wanted period of time
detection range: slider to be able to change the detection range that can be used
speed: slider to be able to change the speed and how fast the theropod is moving around its envirnment

## THINGS TO NOTICE

The detection range and speed sliders are worth changing to see how they effect the mass.

## THINGS TO TRY

The model is set to have detection range and speed to be sliders, it is worth changing them around to see how it affects the mass of the theropod. 

## EXTENDING THE MODEL

If wanted, into the code the number of theropod agents can be changed to see how the different amounts of competition make a different to the final mass. 

## NETLOGO FEATURES

When completing the experiment behaviour space was used per each time one of the parameters number was changed to have the model run for the wanted period of time. 


## CREDITS AND REFERENCES


Bates, K.T., 2009. How big was" Big Al"?: quantifying the effect of soft tissue and osteological unknowns on mass predictions for allosaurus (dinosauria: theropoda). Palaeontologia Electronica, 12(3), pp.1-33

Nagy, K.A., Girard, I.A. and Brown, T.K., 1999. Energetics of free-ranging mammals, reptiles, and birds. Annual review of nutrition, 19(1), pp.247-277.
 Ruxton, G.D. and Houston, D.C., 2004. Obligate vertebrate scavengers must be large soaring fliers. Journal of theoretical biology, 228(3), pp.431-436.

Pahl, C. C., & Ruedas, L. A. (2021). Carnosaurs as Apex Scavengers: Agent-based simulations reveal possible vulture analogues in late Jurassic Dinosaurs. Ecological Modelling, 458, 109706

Pahl, C. C., & Ruedas, L. A. (2023). Big boned: How fat storage and other adaptations influenced large theropod foraging ecology. Plos one, 18(11), e0290459.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cow skull
false
0
Polygon -7500403 true true 150 90 75 105 60 150 75 210 105 285 195 285 225 210 240 150 225 105
Polygon -16777216 true false 150 150 90 195 90 150
Polygon -16777216 true false 150 150 210 195 210 150
Polygon -16777216 true false 105 285 135 270 150 285 165 270 195 285
Polygon -7500403 true true 240 150 263 143 278 126 287 102 287 79 280 53 273 38 261 25 246 15 227 8 241 26 253 46 258 68 257 96 246 116 229 126
Polygon -7500403 true true 60 150 37 143 22 126 13 102 13 79 20 53 27 38 39 25 54 15 73 8 59 26 47 46 42 68 43 96 54 116 71 126

cylinder
false
0
Circle -7500403 true true 0 0 300

dinosaur
true
0
Polygon -2674135 true false 90 45
Rectangle -14835848 true false 105 90 120 180
Rectangle -14835848 true false 105 180 225 225
Polygon -14835848 true false 225 195 270 135 225 210 225 210
Rectangle -2674135 true false 135 225 120 255
Rectangle -14835848 true false 120 225 135 255
Rectangle -14835848 true false 195 225 210 255
Circle -16777216 true false 60 60 0
Circle -16777216 true false 60 60 0
Rectangle -14835848 true false 46 50 121 95
Circle -16777216 true false 60 60 0
Circle -16777216 true false 61 54 16
Line -16777216 false 46 83 74 83
Line -16777216 false 74 85 73 80

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

t-rex
true
0
Polygon -13840069 true false 75 60 73 62 73 47 148 47 148 62 163 62 163 107 163 122 178 122 178 137 193 137 193 152 208 152 208 167 208 182 238 182 238 167 253 167 253 122 268 107 268 122 268 212 253 212 253 227 238 227 238 242 208 242 163 242 178 242 178 242 193 242 193 272 178 272 178 287 148 287 148 272 163 272 163 242 150 240 150 255 135 255 135 270 105 270 105 255 120 255 120 240 120 240 120 225 105 225 105 210 90 210 90 210 75 195 75 180 60 180 60 195 45 195 45 165 75 165 75 135 75 120 103 122 105 120 30 120 28 92 30 75 60 60 58 62
Circle -13840069 false false 90 30 0
Circle -7500403 true true 103 53 40
Circle -16777216 true false 104 60 30

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>[energy] of dinosaur</metric>
    <runMetricsCondition>ticks mod 10080 = 0</runMetricsCondition>
    <enumeratedValueSet variable="detection-range">
      <value value="3.85"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment 3.85" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>[energy] of dinosaur</metric>
    <runMetricsCondition>ticks mod 10080 = 0</runMetricsCondition>
    <enumeratedValueSet variable="detection-range">
      <value value="3.85"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment 4.5" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>[energy] of dinosaur</metric>
    <runMetricsCondition>ticks mod 10080 = 0</runMetricsCondition>
    <enumeratedValueSet variable="detection-range">
      <value value="4.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Sensitivity" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [energy] of dinosaur</metric>
    <runMetricsCondition>ticks = 525600</runMetricsCondition>
    <enumeratedValueSet variable="detection-range">
      <value value="3.25"/>
      <value value="3.85"/>
      <value value="4.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment 2.5km" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>[energy] of dinosaur</metric>
    <runMetricsCondition>ticks mod 10080 = 0</runMetricsCondition>
    <enumeratedValueSet variable="detection-range">
      <value value="2.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment  speed 0.004" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>[energy] of dinosaur</metric>
    <runMetricsCondition>ticks mod 10080 = 0</runMetricsCondition>
    <enumeratedValueSet variable="detection-range">
      <value value="3.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed">
      <value value="0.0041"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
