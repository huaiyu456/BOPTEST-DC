within MultiZoneOfficeSimpleAir.BaseClasses;
block Economizer "Controller for economizer"
  import Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes;
  parameter Boolean have_reset = false
    "Set to true to reset the outdoor air damper controllers with the enable signal"
    annotation(Evaluate=true);
  parameter Boolean have_frePro = false
    "Set to true to enable freeze protection (mixed air low temperature control)";
  parameter Modelica.Units.SI.Temperature TFreSet=277.15
    "Lower limit of mixed air temperature for freeze protection"
    annotation (Dialog(enable=have_frePro), Evaluate=true);
  parameter Modelica.Units.SI.TemperatureDifference dTLock(final min=0.1) = 1
    "Temperature difference between return and outdoor air for economizer lockout";
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller";
  parameter Real k = 0.05 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti=120 "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "Enable signal for economizer"
    annotation (Placement(transformation(extent={{-140,170},{-100,210}}),
       iconTransformation(extent={{-40,-40},{40,40}},
        rotation=90,
        origin={0,-140})));
  Buildings.Examples.VAVReheat.BaseClasses.Controls.ControlBus controlBus
    "Control bus" annotation (Placement(transformation(extent={{30,-88},{50,-68}}),
        iconTransformation(extent={{30,-88},{50,-68}})));
  Modelica.Blocks.Interfaces.RealInput uOATSup
    "Control signal for outdoor air damper from supply temperature controller"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
      iconTransformation(extent={{-140,160},{-100,200}})));
  Modelica.Blocks.Interfaces.RealInput TMix if have_frePro
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput yFan "Measured fan speed" annotation (
      Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput TRet "Return air temperature"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealOutput yRet
    "Control signal for return air damper"
    annotation (Placement(transformation(
          extent={{200,-20},{240,20}}),
          iconTransformation(extent={{200,-20},{240, 20}})));
  Modelica.Blocks.Interfaces.RealOutput yOA
    "Control signal for outside air damper" annotation (Placement(
        transformation(extent={{200,60},{240,100}}),iconTransformation(extent={{200,60},
            {240,100}})));
  Modelica.Blocks.Sources.Constant minOADmaxSpe(k=0.32)
    "Minimum outside air damper position at maximum fan speed"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Constant closed(k=0) "Signal to close OA damper"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Reals.PID yOATFre(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=60,
    yMax=1,
    yMin=0,
    reverseActing=false) if have_frePro
    "Controller of outdoor damper to track freeze temperature setpoint"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Controls.OBC.CDL.Reals.Min minFrePro
    "Takes lower signal (limits damper opening for freeze protection)"
    annotation (Placement(transformation(extent={{80,4},{100,24}})));
  Modelica.Blocks.Sources.Constant TFre(k=TFreSet)
    "Setpoint for freeze protection"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.AddParameter invSig(p=1, k=-1)
    "Invert control signal for interlocked damper"
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Modelica.Blocks.Logical.Hysteresis hysLoc(final uLow=0, final uHigh=dTLock)
    "Hysteresis for economizer lockout"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiOA
    "Switch to close outdoor air damper"
    annotation (Placement(transformation(extent={{90,110},{110,130}})));
  Modelica.Blocks.Sources.Constant one(k=1) if not have_frePro
    "Fill value in case freeze protection is disabled"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiModClo
    "Switch between modulating or closing outdoor air damper"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxOutDam
    "Select larger of the outdoor damper signals"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.Constant minOADminSpe(k=0.47)
    "Minimum outside air damper position at minimum fan speed"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant minSpe(k=0.44)
    "Minimum fan speed for calibration"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(yOATFre.y, minFrePro.u1)
    annotation (Line(points={{-8,80},{0,80},{0,20},{78,20}}, color={0,0,127}));
  connect(yRet, invSig.y)
    annotation (Line(points={{220,0},{192,0}}, color={0,0,127}));
  connect(feedback.y, hysLoc.u)
    annotation (Line(points={{-71,120},{-32,120}}, color={0,0,127}));
  connect(TRet, feedback.u1) annotation (Line(points={{-120,120},{-88,120}},
                      color={0,0,127}));
  connect(controlBus.TOut, feedback.u2) annotation (Line(
      points={{40,-78},{-80,-78},{-80,112}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(closed.y, swiOA.u3) annotation (Line(points={{51,40},{60,40},{60,112},
          {88,112}}, color={0,0,127}));
  connect(hysLoc.y, swiOA.u2)
    annotation (Line(points={{-9,120},{88,120}}, color={255,0,255}));
  connect(uOATSup, swiOA.u1) annotation (Line(points={{-120,160},{60,160},{60,128},
          {88,128}}, color={0,0,127}));

  connect(one.y, minFrePro.u1)
    annotation (Line(points={{-39,20},{78,20}}, color={0,0,127}));
  connect(yOATFre.u_s, TFre.y)
    annotation (Line(points={{-32,80},{-39,80}}, color={0,0,127}));
  connect(TMix, yOATFre.u_m)
    annotation (Line(points={{-120,40},{-20,40},{-20,68}}, color={0,0,127}));
  connect(swiModClo.y, invSig.u)
    annotation (Line(points={{152,0},{168,0}}, color={0,0,127}));
  connect(swiModClo.y, yOA) annotation (Line(points={{152,0},{160,0},{160,80},{220,
          80}}, color={0,0,127}));
  connect(uEna, swiModClo.u2) annotation (Line(points={{-120,190},{140,190},{
          140,20},{124,20},{124,0},{128,0}},
                                         color={255,0,255}));
  connect(closed.y, swiModClo.u3) annotation (Line(points={{51,40},{120,40},{120,
          -8},{128,-8}}, color={0,0,127}));
  connect(maxOutDam.u1, swiOA.y) annotation (Line(points={{38,6},{20,6},{20,100},
          {120,100},{120,120},{112,120}}, color={0,0,127}));
  connect(minFrePro.y, swiModClo.u1) annotation (Line(points={{102,14},{114,14},
          {114,8},{128,8}}, color={0,0,127}));
  connect(maxOutDam.y, minFrePro.u2)
    annotation (Line(points={{62,0},{72,0},{72,8},{78,8}}, color={0,0,127}));
  connect(lin.y, maxOutDam.u2) annotation (Line(points={{12,-30},{26,-30},{26,-6},
          {38,-6}}, color={0,0,127}));
  connect(lin.u, yFan) annotation (Line(points={{-12,-30},{-20,-30},{-20,-60},{-120,
          -60}}, color={0,0,127}));
  connect(minOADminSpe.y, lin.f1) annotation (Line(points={{-39,-40},{-24,-40},{
          -24,-26},{-12,-26}}, color={0,0,127}));
  connect(lin.f2, minOADmaxSpe.y) annotation (Line(points={{-12,-38},{-22,-38},{
          -22,-70},{-39,-70}}, color={0,0,127}));
  connect(lin.x2, minFrePro.u1) annotation (Line(points={{-12,-34},{-14,-34},{-14,
          20},{78,20}}, color={0,0,127}));
  connect(minSpe.y, lin.x1) annotation (Line(points={{-39,-10},{-16,-10},{-16,-22},
          {-12,-22}}, color={0,0,127}));
  annotation (defaultComponentName="conEco",
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            200}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,200}}),
                    graphics={
        Rectangle(
          extent={{-100,200},{200,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,110},{-52,90}},
          lineColor={0,0,255},
          textString="TRet"),
        Text(
          extent={{-92,32},{-52,12}},
          lineColor={0,0,255},
          textString="TMix"),
        Text(
          extent={{-92,-36},{-24,-84}},
          lineColor={0,0,255},
          textString="VOut_flow"),
        Text(
          extent={{138,96},{184,62}},
          lineColor={0,0,255},
          textString="yOA"),
        Text(
          extent={{140,20},{186,-14}},
          lineColor={0,0,255},
          textString="yRet"),
        Text(
          extent={{-92,194},{-24,170}},
          lineColor={0,0,255},
          textString="uOATSup"),        Text(
        extent={{-140,288},{240,214}},
        textString="%name",
        lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
This is a controller for an economizer, that adjusts the mixed air dampers
to fulfill three control functions.
It is based on Buildings.Examples.VAVReheat.BaseClasses.Controls.Economizer
but edited to not use outside airflow measurement for outside air flow
control and instead adjust the minimum outside air damper position
based on fan speed linearly between support points assumed to be determined
during commissioning.
</p>
<ol>
<li>
Freeze protection, based on the mixed air temperature measurement
</li>
<li>
Minimum outside air requirement, based on supply fan speed.
</li>
<li>
Supply air cooling, based on the logic implemented in
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.SupplyAirTemperature\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.SupplyAirTemperature</a>,
with the additional condition that when the outside air dry bulb is greater
than the return air dry bulb, economizer cooling is disabled.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 31, 2021, by Michael Wetter:<br/>
Corrected selection of control signal during freeze protection.
</li>
<li>
October 27, 2020, by Antoine Gautier:<br/>
Refactored for compatibility with new supply air temperature control.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Added optional reset signal.
Corrected connections to <code>yOATFre</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>
and
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1995\">#1995</a>.
</li>
<li>
December 20, 2016, by Michael Wetter:<br/>
Added type conversion for enumeration when used as an array index.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/602\">#602</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
</ul>
</html>"));
end Economizer;
