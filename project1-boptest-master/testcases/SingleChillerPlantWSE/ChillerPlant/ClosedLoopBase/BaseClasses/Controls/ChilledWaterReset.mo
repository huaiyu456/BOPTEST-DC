within ChillerPlant.ClosedLoopBase.BaseClasses.Controls;
model ChilledWaterReset "Chilled water reset"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPlaRes(
    final min = 0,
    final max = 1,
    final unit="1")
    "Chilled water plant reset control signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x2=1,
    x1=0.5,
    y11=1,
    y21=273.15 + 5.56,
    y10=0.2,
    y20=273.15 + 22) "Translate the control signal for chiller setpoint reset"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gain(k=20*6485)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatPumSet(final unit=
        "Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
      iconTransformation(extent={{100,40},{140,80}})));
equation
  connect(linPieTwo.y[1], gain.u) annotation (Line(points={{-19,-0.7},{-18,-0.7},
          {-18,0},{18,0}}, color={0,0,127}));
  connect(linPieTwo.y[2], TChiWatSupSet) annotation (Line(points={{-19,0.3},{0,
          0.3},{0,70},{120,70}}, color={0,0,127}));
  connect(gain.y, dpChiWatPumSet) annotation (Line(points={{42,0},{60,0},{60,
          -70},{120,-70}}, color={0,0,127}));
  connect(uChiWatPlaRes, linPieTwo.u)
    annotation (Line(points={{-120,0},{-42,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
          Text(
          extent={{-54,34},{44,-28}},
          lineColor={28,108,200},
          textString="CHW
Reset")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end ChilledWaterReset;
