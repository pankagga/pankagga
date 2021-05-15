14.5	CPU 

ResNode Macro
----------------
As a starting point, you can examine ResUsage:

Calculating parallel efficiency using ResUsage
-----------------------------------------------
The ResNode macro (DBC.ResGeneralInfoView) provides the following:

/* Parallel efficiency of total pct of time CPUs were busy */
(AVG(CPUBusy)*100)/NULLIFZERO(MAX(CPUBusy))
(FORMAT 'ZZ9', TITLE 'CPU//Eff//  %'),
/* Parallel efficiency of the logical device IOs */
AVG(LogicalDeviceIO)*100 / NULLIFZERO(MAX(LogicalDeviceIO))
(FORMAT 'ZZ9', TITLE 'Ldv//Eff//  %'),

---------------------------------------------------------



