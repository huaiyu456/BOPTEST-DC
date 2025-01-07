within ;
package BESTESTHydronicHeatPump "Test case based on BESTEST model that uses a heat pump as heating production system and floor heating as heating emission system"

annotation (uses(                        Modelica(version="4.0.0"), IDEAS(
          version="3.0.0")),
    version="2",
    conversion(from(version={"1",""}, script=
            "modelica://BESTESTHydronicHeatPump/ConvertFromBESTESTHydronicHeatPump_1.mos")));
end BESTESTHydronicHeatPump;
