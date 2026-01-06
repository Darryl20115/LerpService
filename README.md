# LerpService #
LerpService is a library that allows you to create Lerps and easily modify them.


# Documentation #

````lua
LerpService.create(Object: BasePart,Cframe: CFrame,Goal: CFrame,LerpInfo: LerpInfo)
````
Creates a lerp object.
You should only pass 1 argument
between Object or Cframe </br>
If both are passed then LerpService will
use the Object instead.

````lua
LerpService.NewLerpInfo(duration: number,EasingStyle: Enum.EasingStyle,EasingDirection: Enum.EasingDirection,repeatCount: number,reverses: boolean,delayTime: number)
````
Creates a lerp info.
If repeatCount is less or equal to -1 then the lerp will be infinite.
If lerp is infinite and the duration is 0, LerpService will warn you.

This lerp info should be passed to the ````LerpService.create()```` method.

# Lerp #
# Properties #
### All of the properties can be modified ###
#### Not recommended to modify the properties tagged as read-only. ####
-----------------------------
````lua
Lerp.Object : BasePart
````
The object the lerp was created with, this property will be nill if a Cframe was passed during the creation of the lerp.

-----------------------------
````lua
Lerp.Playing : boolean
````
Lerp is playing
(Setting the lerp playing to true will not play the lerp, use ````Lerp:Play()```` instead) <br/>
<strong/> (This property should be used as read-only) <strong/>

-----------------------------
````lua
Lerp.Info : LerpInfo
````
The LerpInfo table the lerp was created with.

-----------------------------
````lua
Lerp.Id : number
````
The id of the lerp when created. 
<strong/> (This property should be used as read-only) <strong/>

-----------------------------
````lua
Lerp.Time
````
Time in seconds the lerp has been playing through.

-----------------------------
````lua
Lerp.CurrentCFrame
````
The CFrame the lerp is currently in.
(This property only is created if a Cframe is passed and no object is passed)

-----------------------------
````lua
Lerp.Goal
````
The CFrame the lerp is moving to.

-----------------------------
````lua
Lerp.DTime
````
The time that has gone through since delay started and finished.
If its 0 then the lerp is not on delay.

-----------------------------
````lua
Lerp.Loop
````
The current amount of routes lerp has completed.

-----------------------------
````lua
Lerp.Alpha
````
The alpha the lerp was sent to play with.

-----------------------------
````lua
Lerp.Reverse
````
Indicates if the lerp is doing a reverse move.

-----------------------------
````lua
Lerp.Starting
````
The starting cframe of the lerp.


# Methods

````lua
Lerp:Play(alpha: number)
````
The lerp object will be played based on the alpha value.

````lua
Lerp:Stop()
````
The lerp object will be stopped.

````lua
Lerp:Delete()
````
The lerp object will be deleted.

# Signals

````lua
Lerp.Completed
````
Whenever a lerp is completed this signal will recieve a message.

````lua
Lerp.Stopped
````
Whenever a lerp is stopped this signal will recieve a message.

````lua
Lerp.Deleted
````
Whenever a lerp is deleted this signal will recieve a message.

# Change Log

## v1.0.1
Added connection type strict support.

## v1.0.2
Optimized LerpService.
