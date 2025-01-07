within ChillerPlant.ClosedLoopBase;
model OneDeviceWithWSE
  "Simple chiller plant with a water-side economizer and one of each: chiller, cooling tower cell, condenser, and chiller water pump."
  extends ChillerPlant.BaseClasses.DataCenter(
    mCW_flow_nominal = 2*roo.QRoo_flow/(4200*6),
    chi(
      allowFlowReversal1=false,
      m1_flow_nominal=mCW_flow_nominal/2,
      m2_flow_nominal=mCHW_flow_nominal,
      dp1_nominal=42000 + 1444/2,
      dp2_nominal=19000,
      per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_563kW_10_61COP_Vanes()),
    pumCHW(m_flow_nominal=mCHW_flow_nominal, dp_nominal=1000 + 12000 + 15000 +
          3500 + 24000),
    cooCoi(m1_flow_nominal=mCHW_flow_nominal),
    val1(m_flow_nominal=mCHW_flow_nominal,
      dpValve_nominal=200,
      dpFixed_nominal=800),
    TCHWEntChi(m_flow_nominal=mCHW_flow_nominal),
    valByp(m_flow_nominal=mCHW_flow_nominal,
      dpValve_nominal=200,
      use_inputFilter=false,
      dpFixed_nominal=3300),
    val6(m_flow_nominal=mCHW_flow_nominal,
      dpValve_nominal=200,
      dpFixed_nominal=3300),
    cooTow(m_flow_nominal=1.1*mCW_flow_nominal, dp_nominal=15000 + 2887 - 400),
    expVesCHW(p=100000),
    val3(dpValve_nominal=200, dpFixed_nominal=800),
    roo(QRoo_flow=500000,
        nPorts=2),
    mFanFlo(k=mAir_flow_nominal),
    wse(dp1_nominal=42000 + 1444/2),
    weaData(filNam=
          "D:/3Dexperience/Buildings11.0/Buildings-v11.0.0/Buildings 11.0.0/Resources/weatherdata/CHN_Guangdong.Shenzhen.594930_SWERA.mos"));
  extends ChillerPlant.BaseClasses.EnergyMonitoring;
  extends Modelica.Icons.Example;

  Modelica.Units.SI.Power PWSEWatPum;

  Modelica.Units.SI.Power PCooTowWatPum;

  parameter Real dTChi(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2.2
    "Deadband to avoid chiller short-cycling"
    annotation(Dialog(group="Design parameters"));

  BaseClasses.Controls.WaterSideEconomizerOnOff waterSideEconomizerOnOff(
      cooTowAppDes=cooTowAppDes) "Water-side economizer enable/disable"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}})));
  BaseClasses.Controls.ChillerOnOff chillerOnOff(
    dTChi = dTChi)
    annotation (Placement(transformation(extent={{-160,0},{-120,40}})));
  BaseClasses.Controls.ChilledWaterReset chilledWaterReset(linPieTwo(y10=0.1))
    "Chilled water reset controller"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}})));
  BaseClasses.Controls.PlantOnOffWithAnalogueTrimAndRespond plantOnOff(
      TZonSupSet=TZonSupSet, triAndRes1(conPID(
        k=0.1,
        Ti=120,
        strict=true)))       "Plant enable/disable status"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium
      = MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={300,227},
        rotation=90)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dp(start=33000 + 1444),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dpMax=60000)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={160,120})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCWWSE(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal/2,
    dp(start=33000 + 1444 + 200),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dpMax=60000)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={40,142})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    use_inputFilter=false,
    riseTime=30,
    m_flow_nominal=mCW_flow_nominal/2,
    dpValve_nominal=6000,
    fraK=0.7)
            "Chiller head pressure bypass valve"      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,140})));
  BaseClasses.Controls.CondenserWater condenserWater(
    mCW_flow_nominal=mCW_flow_nominal,
    chiFloDivWseFlo=0.5,
    PLRMinUnl=chi.per.PLRMinUnl,
    heaPreCon(reverseActing=true)) "Condenser water controller"
    annotation (Placement(transformation(extent={{-80,200},{-40,240}})));
  Modelica.Blocks.Sources.RealExpression PWSEWatPum1(y=PWSEWatPum)
    "WSE water pump power consumption" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-510,20})));
  Modelica.Blocks.Continuous.Integrator PWSEWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0)
    "Condensed water pump power consumption meter for the WSE loop"
    annotation (Placement(transformation(extent={{-460,20},{-440,40}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = Buildings.Media.Water,
    from_dp=true,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={1.1*mCW_flow_nominal,-1*mCW_flow_nominal,-0.1*
        mCW_flow_nominal},
    dp_nominal=200*{1,-1,-1})                   "Splits flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,200})));
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium = Buildings.Media.Water,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={1.1*mCW_flow_nominal,-1*mCW_flow_nominal,0.1*
        mCW_flow_nominal},
    dp_nominal=200*{1,-1,1})                    "Joins two flows"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,200})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCT(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=1.1*mCW_flow_nominal,
    dp(start=15000 + 2887),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling tower loop pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={126,240})));
  Buildings.Fluid.Sources.Boundary_pT expVesWSE(redeclare package Medium =
        MediumW,
    p=100000,    nPorts=1) "Represents an expansion vessel"
    annotation (Placement(transformation(extent={{50,111},{70,131}})));
  Modelica.Blocks.Sources.RealExpression PCTWatPum(y=PCooTowWatPum)
    "Cooling tower water pump power consumption" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-510,-20})));
  Modelica.Blocks.Continuous.Integrator PCooTowWatPumAgg(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Cooling tower pump power consumption meter for the WSE loop"
    annotation (Placement(transformation(extent={{-460,-20},{-440,0}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=200,
    dpFixed_nominal=1244,
    y_start=0,
    use_inputFilter=false)
    "Control valve for condenser water loop of economizer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,120})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=chi.PLR2)
    annotation (Placement(transformation(extent={{-146,194},{-126,214}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{212,60},{224,72}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{120,-14},{108,-2}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{150,-18},{140,-8}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{334,130},{314,150}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{264,218},{252,230}})));
  Modelica.Blocks.Sources.Constant const3(k=0)
    annotation (Placement(transformation(extent={{284,208},{274,218}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWWseLea(redeclare package Medium
      = MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={40,175},
        rotation=90)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWChiLea(redeclare package Medium
      = MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={140,157},
        rotation=90)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWEnt(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={166,235},
        rotation=180)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWOut(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water entering chiller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={302,-64})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveChiTset(final u,
      description="The set temperature of the chiller")
    "Overwirte the set temperature of the chiller"
    annotation (Placement(transformation(extent={{134,46},{154,66}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveVal6(final u, description=
        "on / off of the value 6 in the chiller output pipe")
    "Overwirte on/off of the value 6"
    annotation (Placement(transformation(extent={{254,30},{274,50}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveValByp(final u,
      description="on / off of the Value bypass of the chiller")
    "Overwirte on/off of the value bypass"
    annotation (Placement(transformation(extent={{192,28},{212,48}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveVal1(final u, description=
        "on/off of the value 1 ( the bypass value of WSE) ")
    "Overwirte on/off of the value 1"
    annotation (Placement(transformation(extent={{114,-50},{134,-30}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveVal3(final u, description=
        "on/off of the value 3 ( the input pipe of wse ) ")
    "Overwirte on/off of the value3"
    annotation (Placement(transformation(extent={{22,-28},{42,-8}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite ovepumCHW(final u,
      description="the inset dp of the pump in the chiller water ")
    "Overwirte the dp of the pumCHW"
    annotation (Placement(transformation(extent={{102,-130},{122,-110}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite ovemFanFlo(final u,
      description="the mass flow rate of fan ")
    "Overwirte the mass flow rate of fan"
    annotation (Placement(transformation(extent={{264,-210},{284,-190}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite ovepumCWWSE(final u,
      description="mass flow of the wse condenser water pump ")
    "Overwirte condenser water pump of wse"
    annotation (Placement(transformation(extent={{-2,132},{18,152}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite ovepumCW(final u, description
      ="mass flow of the chiller condenser water pump ")
    "Overwirte  condenser water pump of chiller" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={196,120})));
  Buildings.Utilities.IO.SignalExchange.Overwrite ovepumCT(final u, description
      ="mass flow of the cooling tower loop pump ")
    "Overwirte cooling tower loop pump"
    annotation (Placement(transformation(extent={{44,232},{64,252}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveVal4(final u, description=
        "on / off of the Value4 in the wse condenser pipe")
    "Overwirte on/off of the value 4"
    annotation (Placement(transformation(extent={{102,72},{122,92}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveval(final u, description=
        "on/off of the chiller head pressure bypass valve ")
    "Overwirte chiller head pressure bypass valve"
    annotation (Placement(transformation(extent={{318,168},{338,188}})));
  parameter Modelica.Blocks.Interfaces.RealInput u
    "Connector of Real input signal";
  Buildings.Utilities.IO.SignalExchange.Read readTAirSup(
    y,
    description="Supply air temperature to data center",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature)
    "read Supply air temperature to data center"
    annotation (Placement(transformation(extent={{200,-224},{180,-204}})));
  Buildings.Utilities.IO.SignalExchange.Read readTCHWLeaCoi(
    y,
    description="Temperature of chilled water leaving the cooling coil",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
    "read Temperature of chilled water leaving the cooling coil"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  Buildings.Utilities.IO.SignalExchange.Read readTCHWEntChi(
    y,
    description="Temperature of chilled water entering chiller",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
    "read Temperature of chilled water entering chiller"
    annotation (Placement(transformation(extent={{88,-18},{68,2}})));
  Buildings.Utilities.IO.SignalExchange.Read readTCWLeaTow(
    y,
    description="Temperature of condenser water leaving the cooling tower",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
    "read Temperature of condenser water leaving the cooling tower"
    annotation (Placement(transformation(extent={{200,284},{180,304}})));
  Buildings.Utilities.IO.SignalExchange.Read readPAllAgg(
    y,
    description="Meters total power consumption",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
    "Meters total power consumption"
    annotation (Placement(transformation(extent={{-526,246},{-506,266}})));
  Buildings.Utilities.IO.SignalExchange.Read readCO2(
    y,
    description="Concetration of CO2",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.CO2Concentration)
    "Concetration of CO2"
    annotation (Placement(transformation(extent={{-546,-228},{-526,-208}})));
  Modelica.Blocks.Sources.RealExpression conCO2(y=250) "Concetration of CO2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
            -580,-218})));
  Buildings.Utilities.IO.SignalExchange.Overwrite fauChiTset(final u,
      description="The falut temperature of the chiller")
    "Overwirte the fault temperature of the chiller"
    annotation (Placement(transformation(extent={{186,62},{198,74}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=-5,
    width=3.3,
    period(displayUnit="d") = 2592000,
    nperiod=12,
    offset=0,
    startTime(displayUnit="d") = 1296000)
    annotation (Placement(transformation(extent={{164,66},{172,74}})));
  Modelica.Blocks.Sources.Pulse pulse1(
    amplitude=1,
    width=3.3,
    period(displayUnit="d") = 2592000,
    nperiod=12,
    offset=0,
    startTime(displayUnit="d") = 864000)
    annotation (Placement(transformation(extent={{412,106},{390,128}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite fauval(final u, description=
        "The falut Chiller head pressure bypass valve")
    "Overwirte the fault Chiller head pressure bypass valve 0/1"
    annotation (Placement(transformation(extent={{376,106},{354,128}})));
equation
  PSupFan = fan.P;
  PChiWatPum = pumCHW.P;
  PConWatPum = pumCW.P;
  PWSEWatPum = pumCWWSE.P;
  PCooTowWatPum = pumCT.P;
  PCooTowFan = cooTow.PFan;
  PChi = chi.P;
  QRooIntGai_flow = roo.QSou.Q_flow;
  mConWat_flow = pumCW.m_flow_actual;
  mChiWat_flow = pumCHW.VMachine_flow * rho_default;

  connect(weaBus.TWetBul, cooTow.TAir) annotation (Line(
      points={{-329.95,-89.95},{-260,-89.95},{-260,260},{170,260},{170,243},{
          197,243}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(weaBus.TWetBul, waterSideEconomizerOnOff.TWetBul) annotation (Line(
      points={{-329.95,-89.95},{-260,-89.95},{-260,100},{-164,100}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chillerOnOff.yChi, chi.on) annotation (Line(
      points={{-116,34},{-100,34},{-100,78},{236,78},{236,96},{218,96}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(plantOnOff.yChiWatPlaRes, chilledWaterReset.uChiWatPlaRes)
    annotation (Line(points={{-176,-120},{-170,-120},{-170,-40},{-164,-40}},
        color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chilledWaterReset.TChiWatSupSet, chillerOnOff.TChiWatSupSet)
    annotation (Line(
      points={{-116,-28},{-100,-28},{-100,-10},{-180,-10},{-180,6},{-164,6}},
      color={0,0,127},
      pattern=LinePattern.DashDot));
  connect(chi.port_b1, pumCW.port_a) annotation (Line(
      points={{196,99},{196,100},{160,100},{160,110}},
      color={28,108,200},
      thickness=0.5));
  connect(waterSideEconomizerOnOff.ySta,
    condenserWater.uWSE) annotation (Line(
      points={{-116,88},{-108,88},{-108,236},{-84,236}},
      color={255,0,255},
      pattern=LinePattern.DashDot));
  connect(chillerOnOff.yChi, condenserWater.uChi)
    annotation (Line(
      points={{-116,34},{-100,34},{-100,220},{-84,220}},
      color={255,0,255},
      pattern=LinePattern.DashDot));

  connect(condenserWater.yTowFanSpeSet, cooTow.y)
    annotation (Line(
      points={{-36,236},{-8,236},{-8,270},{194,270},{194,247},{197,247}},
      color={0,0,127},
      pattern=LinePattern.Dot));

  connect(PWSEWatPum1.y, PWSEWatPumAgg.u) annotation (Line(
      points={{-499,20},{-480,20},{-480,30},{-462,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val.port_2, chi.port_a1) annotation (Line(points={{300,130},{300,99},{
          216,99}},                     color={0,128,255},
      thickness=0.5));
  connect(TCWLeaTow.port_b, spl.port_1)
    annotation (Line(points={{300,217},{300,210}}, color={0,127,255},
      thickness=0.5));
  connect(mix.port_3, spl.port_3)
    annotation (Line(points={{110,200},{290,200}}, color={0,127,255}));
  connect(wse.port_a1, expVesWSE.ports[1]) annotation (Line(points={{68,99},{80,
          99},{80,121},{70,121}},color={0,127,255}));
  connect(PCTWatPum.y, PCooTowWatPumAgg.u) annotation (Line(
      points={{-499,-20},{-480,-20},{-480,-10},{-462,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wse.port_b1, pumCWWSE.port_a)
    annotation (Line(points={{48,99},{44,99},{44,100},{40,100},{40,132}},
                                                        color={0,127,255},
      thickness=0.5));
  connect(mix.port_2, pumCT.port_a) annotation (Line(points={{100,210},{100,240},
          {116,240}},           color={0,127,255},
      thickness=0.5));
  connect(cooTow.port_b, TCWLeaTow.port_a) annotation (Line(points={{219,239},{260,
          239},{260,240},{300,240},{300,237}},
                                         color={0,127,255},
      thickness=0.5));
  connect(roo.airPorts[2], cooCoi.port_a2) annotation (Line(
      points={{190.45,-229.3},{188,-229.3},{188,-226},{160,-226},{160,-176},{
          222,-176}},
      color={0,127,255},
      thickness=0.5));
  connect(pumCW.port_b, val.port_3) annotation (Line(points={{160,130},{160,140},
          {290,140}}, color={0,127,255}));
  connect(val4.port_b, wse.port_a1)
    annotation (Line(points={{120,110},{120,99},{68,99}}, color={0,127,255}));
  connect(spl.port_2, val.port_1)
    annotation (Line(points={{300,190},{300,150}}, color={0,127,255}));
  connect(spl.port_2, val4.port_a) annotation (Line(points={{300,190},{300,160},
          {120,160},{120,130}}, color={0,127,255}));
  connect(condenserWater.uChiPLR, realExpression.y)
    annotation (Line(points={{-84,204},{-125,204}}, color={0,0,127}));
  connect(TCHWEntChi.T, add1.u1) annotation (Line(points={{149,2.05391e-15},{
          136,2.05391e-15},{136,-4.4},{121.2,-4.4}}, color={238,46,47}));
  connect(const1.y, add1.u2) annotation (Line(points={{139.5,-13},{130,-13},{
          130,-11.6},{121.2,-11.6}}, color={238,46,47}));
  connect(val.y, max1.y) annotation (Line(points={{312,140},{312,139},{313,139},
          {313,140}}, color={0,0,127}));
  connect(TCWLeaTow.T, add2.u1) annotation (Line(points={{289,227},{277.1,227},
          {277.1,227.6},{265.2,227.6}}, color={255,0,0}));
  connect(add2.u2, const3.y) annotation (Line(points={{265.2,220.4},{265.2,213},
          {273.5,213}}, color={255,0,0}));
  connect(pumCWWSE.port_b, TCWWseLea.port_a)
    annotation (Line(points={{40,152},{40,165}}, color={0,127,255}));
  connect(TCWWseLea.port_b, mix.port_1) annotation (Line(points={{40,185},{40,
          188},{100,188},{100,190}}, color={0,127,255}));
  connect(pumCW.port_b, TCWChiLea.port_a) annotation (Line(points={{160,130},{
          152,130},{152,147},{140,147}}, color={0,127,255}));
  connect(TCWChiLea.port_b, mix.port_1) annotation (Line(points={{140,167},{120,
          167},{120,180},{100,180},{100,190}}, color={0,127,255}));
  connect(pumCT.port_b, TCWEnt.port_a) annotation (Line(points={{136,240},{146,
          240},{146,235},{156,235}}, color={0,127,255}));
  connect(cooTow.port_a, TCWEnt.port_b) annotation (Line(points={{199,239},{188,
          239},{188,235},{176,235}}, color={0,127,255}));
  connect(val6.port_b, TCHWOut.port_a)
    annotation (Line(points={{300,30},{300,-54},{302,-54}},
                                                  color={0,127,255}));
  connect(cooCoi.port_a1, TCHWOut.port_b) annotation (Line(points={{242,-164},{
          268,-164},{268,-160},{302,-160},{302,-74}}, color={0,127,255}));
  connect(chilledWaterReset.TChiWatSupSet, oveChiTset.u) annotation (Line(
        points={{-116,-28},{-76,-28},{-76,56},{132,56}}, color={0,0,127}));
  connect(oveChiTset.y, add.u2) annotation (Line(points={{155,56},{200,56},{200,
          62.4},{210.8,62.4}}, color={0,0,127}));
  connect(chillerOnOff.yOn, oveVal6.u) annotation (Line(points={{-116,20},{68,
          20},{68,40},{252,40}}, color={0,0,127}));
  connect(val6.y, oveVal6.y)
    annotation (Line(points={{288,40},{275,40}}, color={0,0,127}));
  connect(valByp.y, oveValByp.y) annotation (Line(points={{230,32},{222,32},{
          222,38},{213,38}}, color={0,0,127}));
  connect(chillerOnOff.yOff, oveValByp.u) annotation (Line(points={{-116,6},{
          -38,6},{-38,12},{126,12},{126,30},{190,30},{190,38}}, color={0,0,127}));
  connect(waterSideEconomizerOnOff.yOff, oveVal1.u) annotation (Line(points={{
          -116,100},{-60,100},{-60,-40},{112,-40}}, color={0,0,127}));
  connect(oveVal1.y, val1.y)
    annotation (Line(points={{135,-40},{148,-40}}, color={0,0,127}));
  connect(waterSideEconomizerOnOff.yOn, oveVal3.u) annotation (Line(points={{
          -116,112},{2,112},{2,-18},{20,-18}}, color={0,0,127}));
  connect(oveVal3.y, val3.y)
    annotation (Line(points={{43,-18},{60,-18},{60,-48}}, color={0,0,127}));
  connect(chilledWaterReset.dpChiWatPumSet, ovepumCHW.u) annotation (Line(
        points={{-116,-52},{-20,-52},{-20,-120},{100,-120}}, color={0,0,127}));
  connect(ovepumCHW.y, pumCHW.dp_in)
    annotation (Line(points={{123,-120},{148,-120}}, color={0,0,127}));
  connect(mFanFlo.y, ovemFanFlo.u)
    annotation (Line(points={{261,-200},{262,-200}}, color={0,0,127}));
  connect(ovemFanFlo.y, fan.m_flow_in) annotation (Line(points={{285,-200},{288,
          -200},{288,-213},{280,-213}}, color={0,0,127}));
  connect(condenserWater.mWSEConWatPumSet_flow, ovepumCWWSE.u) annotation (Line(
        points={{-36,220},{-10,220},{-10,142},{-4,142}}, color={0,0,127}));
  connect(ovepumCWWSE.y, pumCWWSE.m_flow_in)
    annotation (Line(points={{19,142},{28,142}}, color={0,0,127}));
  connect(condenserWater.mChiConWatPumSet_flow, ovepumCW.u) annotation (Line(
        points={{-36,228},{80,228},{80,146},{216,146},{216,120},{208,120}},
        color={0,0,127}));
  connect(ovepumCW.y, pumCW.m_flow_in)
    annotation (Line(points={{185,120},{172,120}}, color={0,0,127}));
  connect(condenserWater.mCTConWatPumSet, ovepumCT.u) annotation (Line(points={
          {-36,212},{-8,212},{-8,232},{40,232},{40,242},{42,242}}, color={0,0,
          127}));
  connect(ovepumCT.y, pumCT.m_flow_in) annotation (Line(points={{65,242},{96,
          242},{96,228},{126,228}}, color={0,0,127}));
  connect(waterSideEconomizerOnOff.yOn, oveVal4.u) annotation (Line(points={{
          -116,112},{0,112},{0,82},{100,82}}, color={0,0,127}));
  connect(oveVal4.y, val4.y) annotation (Line(points={{123,82},{140,82},{140,
          120},{132,120}}, color={0,0,127}));
  connect(condenserWater.yChiConMix, oveval.u) annotation (Line(points={{-36,
          204},{24,204},{24,178},{316,178}}, color={0,0,127}));
  connect(oveval.y, max1.u1) annotation (Line(points={{339,178},{348,178},{348,
          146},{336,146}}, color={0,0,127}));
  connect(plantOnOff.TZonSup, readTAirSup.y) annotation (Line(points={{-224,
          -120},{-248,-120},{-248,-214},{179,-214}}, color={0,0,127}));
  connect(readTAirSup.u, TAirSup.T)
    annotation (Line(points={{202,-214},{230,-214}}, color={0,0,127}));
  connect(TCHWLeaCoi.T, readTCHWLeaCoi.u)
    annotation (Line(points={{149,-80},{122,-80}}, color={0,0,127}));
  connect(readTCHWLeaCoi.y, waterSideEconomizerOnOff.TChiWatRet) annotation (
      Line(points={{99,-80},{-200,-80},{-200,112},{-164,112}}, color={0,0,127}));
  connect(chillerOnOff.TChiWatRetDow, readTCHWEntChi.y) annotation (Line(points
        ={{-164,34},{-192,34},{-192,-8},{67,-8}}, color={0,0,127}));
  connect(readTCHWEntChi.u, add1.y)
    annotation (Line(points={{90,-8},{107.4,-8}}, color={0,0,127}));
  connect(waterSideEconomizerOnOff.TConWatSup, readTCWLeaTow.y) annotation (
      Line(points={{-164,86},{-180,86},{-180,294},{179,294}}, color={0,0,127}));
  connect(readTCWLeaTow.u, add2.y) annotation (Line(points={{202,294},{238,294},
          {238,224},{251.4,224}}, color={0,0,127}));
  connect(PAllAgg.y, readPAllAgg.u) annotation (Line(points={{-539,240},{-536,
          240},{-536,256},{-528,256}}, color={0,0,127}));
  connect(readCO2.u, conCO2.y)
    annotation (Line(points={{-548,-218},{-569,-218}}, color={0,0,127}));
  connect(add.u1, fauChiTset.y) annotation (Line(points={{210.8,69.6},{206,69.6},
          {206,68},{198.6,68}}, color={0,0,127}));
  connect(chi.TSet, add.y) annotation (Line(points={{218,90},{230,90},{230,66},
          {224.6,66}}, color={0,0,127}));
  connect(fauChiTset.u, pulse.y) annotation (Line(points={{184.8,68},{180,68},{
          180,70},{172.4,70}}, color={0,0,127}));
  connect(max1.u2, fauval.y) annotation (Line(points={{336,134},{336,128},{
          352.9,128},{352.9,117}}, color={0,0,127}));
  connect(pulse1.y, fauval.u)
    annotation (Line(points={{388.9,117},{378.2,117}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "/home/milicag/repos/obc/examples/case_study_2/scripts/ClosedLoopBase/OneDeviceWithWSE.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is the chilled water plant with continuous time control.
The trim and respond logic is approximated by a PI controller which
significantly reduces computing time. The model is described at
<a href=\"Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
<p>
See
<a href=\"Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl</a>
for an implementation with the discrete time trim and respond logic.
</p>
</html>", revisions="<html>
<ul>
<li>
July xx, 2021, by Milica Grahovac:<br/>
Revised pressure drops, packaged sub-controllers, and added metering panel.
</li>
<li>
January 13, 2015, by Michael Wetter:<br/>
Moved base model to
<a href=\"Buildings.Examples.ChillerPlant.BaseClasses.DataCenter\">
Buildings.Examples.ChillerPlant.BaseClasses.DataCenter</a>.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-660,-300},{400,320}}), graphics={
        Text(
          extent={{-226,-142},{-168,-162}},
          textColor={238,46,47},
          textString="PI未调谐"),
        Text(
          extent={{174,4},{242,-38}},
          textColor={238,46,47},
          textString="chi回水温度"),
        Text(
          extent={{300,98},{422,58}},
          textColor={238,46,47},
          textString="阀门卡住
（这个模型只有1/0）"),
        Text(
          extent={{314,238},{402,192}},
          textColor={238,46,47},
          textString="冷却塔出水温度"),
        Text(
          extent={{232,90},{300,48}},
          textColor={238,46,47},
          textString="chi出水温度"),
        Text(
          extent={{-608,-172},{-502,-200}},
          lineColor={28,108,200},
          textString="con CO2 数值需更改")}),
    experiment(
      StopTime=31536000,
      Tolerance=0.001,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-660,-300},{400,320}})));
end OneDeviceWithWSE;
