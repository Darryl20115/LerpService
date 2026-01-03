# LerpService
LerpService is a library that allows you to create Lerps and easily modify them.


# Documentation

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

# Lerp

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
