---

title: "Making a top down car racer in Godot"
date: 2021-03-31T22:30:03+02:00
author: "Me"
tags: ["godot"]
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: true
description: "Tutorial on how to implement physics of a top down car kinematic body"
disableHLJS: false
disableShare: true
searchHidden: true

---


## Introducing variables

This section is work in progress

## Rotating the direction vector

### Option 1: Calculating it from an angle

{{< rawhtml >}}
<iframe
src="https://www.geogebra.org/calculator/rzjz487c?embed"
width="800" height="600"
allowfullscreen
style="border: 1px solid #e4e4e4;border-radius: 4px;"
frameborder="0">
</iframe>
{{</rawhtml>}}

### Option 2: Maybe faster

Needs to be normalized
perpendicular vector
work in progress

## Full code

Car.gd

```gdscript
{{% include "content/posts/godot-topdown-car/car.gd" %}}
```
