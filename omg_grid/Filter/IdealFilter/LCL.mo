within omg_grid.Filter.IdealFilter;

model LCL
  parameter SI.Capacitance C1 = 0.00001;
  parameter SI.Capacitance C2 = 0.00001;
  parameter SI.Capacitance C3 = 0.00001;
  parameter SI.Inductance L1 = 0.001;
  parameter SI.Inductance L2 = 0.001;
  parameter SI.Inductance L3 = 0.001;
  parameter SI.Inductance L4 = 0.001;
  parameter SI.Inductance L5 = 0.001;
  parameter SI.Inductance L6 = 0.001;
  Modelica.Electrical.Analog.Basic.Inductor inductor1(L = L1) annotation(
    Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor2(L = L2) annotation(
    Placement(visible = true, transformation(origin = {-60, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor3(L = L3) annotation(
    Placement(visible = true, transformation(origin = {-60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.Pin pin3 annotation(
    Placement(visible = true, transformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.Pin pin1 annotation(
    Placement(visible = true, transformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.Pin pin2 annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor1(C = C1) annotation(
    Placement(visible = true, transformation(origin = {32, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor2(C = C2) annotation(
    Placement(visible = true, transformation(origin = {12, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor3(C = C3) annotation(
    Placement(visible = true, transformation(origin = {-8, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(visible = true, transformation(origin = {12, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.Pin pin6 annotation(
    Placement(visible = true, transformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.Pin pin4 annotation(
    Placement(visible = true, transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.Pin pin5 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor4(L = L4) annotation(
    Placement(visible = true, transformation(origin = {68, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor5(L = L5) annotation(
    Placement(visible = true, transformation(origin = {74, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor6(L = L6) annotation(
    Placement(visible = true, transformation(origin = {64, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(inductor2.n, inductor5.p) annotation(
    Line(points = {{-50, 44}, {-50, 44}, {-50, 44}, {64, 44}}, color = {0, 0, 255}));
  connect(inductor2.n, capacitor2.p) annotation(
    Line(points = {{-50, 44}, {12, 44}, {12, -26}, {12, -26}}, color = {0, 0, 255}));
  connect(inductor1.n, inductor4.p) annotation(
    Line(points = {{-50, 20}, {-50, 20}, {-50, 20}, {58, 20}}, color = {0, 0, 255}));
  connect(inductor1.n, capacitor1.p) annotation(
    Line(points = {{-50, 20}, {32, 20}, {32, -26}, {32, -26}}, color = {0, 0, 255}));
  connect(inductor3.n, capacitor3.p) annotation(
    Line(points = {{-50, 70}, {-8, 70}, {-8, -26}, {-8, -26}}, color = {0, 0, 255}));
  connect(inductor3.n, inductor6.p) annotation(
    Line(points = {{-50, 70}, {54, 70}, {54, 70}, {54, 70}}, color = {0, 0, 255}));
  connect(inductor4.n, pin4) annotation(
    Line(points = {{78, 20}, {80, 20}, {80, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(inductor6.n, pin6) annotation(
    Line(points = {{74, 70}, {84, 70}, {84, 60}, {100, 60}}, color = {0, 0, 255}));
  connect(pin1, inductor1.p) annotation(
    Line(points = {{-100, -60}, {-85, -60}, {-85, 20}, {-70, 20}}, color = {0, 0, 255}));
  connect(pin3, inductor3.p) annotation(
    Line(points = {{-100, 60}, {-93, 60}, {-93, 70}, {-70, 70}}, color = {0, 0, 255}));
  connect(inductor5.n, pin5) annotation(
    Line(points = {{84, 44}, {88, 44}, {88, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(pin2, inductor2.p) annotation(
    Line(points = {{-100, 0}, {-91, 0}, {-91, 44}, {-70, 44}}, color = {0, 0, 255}));
  connect(capacitor2.n, ground1.p) annotation(
    Line(points = {{12, -46}, {12, -46}, {12, -58}, {12, -58}}, color = {0, 0, 255}));
  connect(capacitor2.n, capacitor1.n) annotation(
    Line(points = {{12, -46}, {32, -46}, {32, -46}, {32, -46}}, color = {0, 0, 255}));
  connect(capacitor3.n, capacitor2.n) annotation(
    Line(points = {{-8, -46}, {12, -46}, {12, -46}, {12, -46}}, color = {0, 0, 255}));
end LCL;
