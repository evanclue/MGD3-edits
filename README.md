# Mungydodance 3

The following project has been in-officially taken over by me (DarkBahamut162).

It's source is being displayed down below.

---

[Mungyodance 3 (StepMania 5)](https://github.com/MadkaT182/MGD3)
---

**Description:** MungyoDance3 Theme port for SM5 

**Date:** Nov 20th 2017 - May 25th 2021

---
This time, I've actually forked this project and did my own changes (most of the changes there were mine either way...) since the my updates to it took way too long to be implemented.

What has been fixed/added by me so far:

* **Two Player Functionality** pretty much everywhere
* Added **Quality of Life** changes
  * Optional changes to ScreenSelectMusic/Course'S **Acceleration** selection
    * Switch **Difficulty Controls** from menu to non-menu input
    * Added **Inverted Controls**
  * Added **In-Game Indications** for the following:
    * **Mines** if the song has them
    * Added **TRUE LENGTH** showing actual duration of the song being played
      * Changed **LENGTH** to **SONG LENGTH** (shows full duration of the song)
    * Changed **BPM** to **DISPLAYBPM** if it has been set and is different to the song's actual bpms
      * Changes color to **RED** if **TRUE BPM** goes beyond current **DISPLAYBPM**
      * Changes color to **ORANGE** if **TRUE BPM** goes beyond current **DISPLAYBPM** but don't last that long
      * Changes color to **GREEN** if **TRUE BPM** goes below current **DISPLAYBPM**
    * Shows **ROLLS** and **LIFTS** in **HOLDS** row if available
    * Shows a **?** in **STEPS** row if song has **FAKES**
  * Added **Difficulty Display Setting** in **Theme Settings** to calculate MGD-like difficulties for all songs
  * Fixed **Life Setting** in **Theme Settings** to calculate MGD-like life amount for all songs
  * **Questions Acceleration** if X-Mods are already used in Courses
  * Forced implementation of **NoteSkin** and selected **Accelerator** in Course/Extra Mode via ApplyGameCommand
  * **Maximum Lives** forcibly set to **100**

Stuff still might need to get fixed and a few more QoL changes need to be implemented, but because of no interest, this project is halted (for now).