within ;
package MultiZoneResidentialHydronic "Package for the development of the multi zone residential hydronic building model BOPTEST test case"

  import Buildings;
  import Construction;











  annotation (uses(
      Modelica_StateGraph2(version="2.0.3"),
      Construction(version="3"),
    ARTEMIS(version="1"),
      Modelica(version="4.0.0"),
      ModelicaServices(version="4.0.0"),
      Buildings(version="11.0.0")),
    version="3",
    conversion(from(version="", script="ConvertFromARTEMIS_.mos",
        to="2"), from(version={"2","1"}, script=
            "modelica://MultiZoneResidentialHydronic/Resources/ConvertFromMultiZoneResidentialHydronic_2.mos")));
end MultiZoneResidentialHydronic;
