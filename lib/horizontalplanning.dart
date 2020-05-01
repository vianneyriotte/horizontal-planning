import 'package:flutter/material.dart';
import 'dart:math' as math;

class HorizontalPlanning extends StatefulWidget {
  final List<String> weekDays;
  final int nbHours;
  final List<String> employees;
  final int startHour;
  final String title;
  final double columnHourWidth;
  final double employeeHeight;
  final double hourHeight;
  final double dayWidth;
  final double employeeWidth;
  final int margin = 0;

  HorizontalPlanning({
    this.title,
    this.startHour = 7,
    this.employees = const [" "],
    this.nbHours = 24,
    this.weekDays = const [
      "Sun.",
      "Mon.",
      "Tue.",
      "Wed.",
      "Thu.",
      "Fri.",
      "Sat."
    ],
    this.columnHourWidth = 50,
    this.employeeHeight = 50,
    this.hourHeight = 20,
    this.dayWidth = 30,
    this.employeeWidth = 60,
    Key key,
  }) : super(key: key);

  @override
  _HorizontalPlanningState createState() => _HorizontalPlanningState();
}

class _HorizontalPlanningState extends State<HorizontalPlanning> {
  int _nbEmployees;
  Size _containerSize;

  @override
  void initState() {
    _nbEmployees = widget.employees.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setContainerSize();
    });
    super.initState();
  }

  void _setContainerSize() {
    setState(() {
      _containerSize =
          (_containerKey.currentContext?.findRenderObject() as RenderBox).size;
    });
  }

  final GlobalKey _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          widget.title != null ? _titleView(context) : Container(),
          Expanded(
            child: _verticalScrollView(context),
          ),
        ],
      ),
    );
  }

  Widget _titleView(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      height: 30,
      child: Text(
        widget.title,
      ),
    );
  }

  Widget _verticalScrollView(BuildContext context) {
    return Container(
      key: _containerKey,
      constraints: BoxConstraints.expand(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildContentPlanning(context),
          ),
        ],
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget _buildUsersLines(
    BuildContext context,
  ) {
    return Column(
      children: List.generate(
        _nbEmployees,
        (index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
            ),
            alignment: Alignment.center,
            width: widget.employeeWidth,
            height: widget.employeeHeight,
            child: Text("${widget.employees[index]}", textScaleFactor: 0.9),
          );
        },
      ),
    );
  }

  Widget _buildDayLines(BuildContext context) {
    return Column(
      children: List.generate(
        _nbEmployees,
        (index) {
          return Container(
            width: widget.columnHourWidth,
            height: widget.employeeHeight,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  style: index < _nbEmployees - 1
                      ? BorderStyle.solid
                      : BorderStyle.none,
                  width: 0.4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayLine(
    BuildContext context,
    String day, {
    bool top = false,
    bool bottom = false,
  }) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            border: Border(
              bottom: BorderSide(
                  style: bottom == false ? BorderStyle.none : BorderStyle.solid,
                  width: 0.3),
              top: BorderSide(
                  style: top == false ? BorderStyle.none : BorderStyle.solid,
                  width: 0.3),
            ),
          ),
          width: widget.dayWidth,
          height: widget.employeeHeight * _nbEmployees,
          child: Transform.rotate(
            angle: -math.pi * 0.50,
            child: Text(
              day,
              textScaleFactor: 0.8,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          alignment: Alignment.center,
        )
      ],
    );
  }

  Widget _buildContentPlanning(BuildContext context) {
    final hauteurContainer = widget.employeeHeight * _nbEmployees * 7 +
        widget.margin * 2 +
        widget.hourHeight * 7;
    return Container(
      // TAILLE EN HAUTEUR DU CONTENEUR (avec le calcul ci-dessus)
      height: hauteurContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COLONNE CONTENANT LA LISTE DES JOURS
          _buildDaysColumn(context),
          // COLONNE CONTENANT LA LISTE DES SALARIE (chaque jour de la semaine)
          _buildEmployeColumns(context),
          // COLONNE CONTENANT LES EVENNEMENTS DU PLANNING
          _horizontalScrollView(hauteurContainer, context),
        ],
      ),
    );
  }

  Widget _horizontalScrollView(double hauteurContainer, BuildContext context) {
    final largeurContainer = () =>
        _containerSize.width -
        widget.dayWidth -
        widget.employeeWidth -
        widget.margin * 2;
    return _containerSize == null
        ? Container()
        : Container(
            height: hauteurContainer,
            width: largeurContainer(),
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: widget.nbHours * widget.columnHourWidth,
                          height: hauteurContainer,
                          child: Column(
                            children: List.generate(
                              7,
                              (idx) {
                                return Column(
                                  children: [
                                    _buildHoursLine(),
                                    Row(
                                      children: List.generate(
                                        widget.nbHours,
                                        (index) {
                                          return Column(
                                            children: [
                                              _buildDayLines(
                                                context,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Container _buildHoursLine() {
    final hours = List.generate(
        24,
        (index) => index + widget.startHour >= widget.nbHours
            ? index + widget.startHour - widget.nbHours
            : index + widget.startHour);
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
      ),
      width: widget.columnHourWidth * widget.nbHours,
      height: widget.hourHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.nbHours,
          (index) {
            return Container(
              color: Colors.blueGrey[50],
              height: widget.hourHeight,
              width: widget.columnHourWidth,
              alignment: Alignment.centerLeft,
              child: Text("${hours[index]}h", textScaleFactor: 0.9),
            );
          },
        ),
      ),
    );
  }

  Column _buildEmployeColumns(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        7,
        (index) {
          return Column(
            children: [
              SizedBox(
                width: widget.dayWidth,
                height: widget.hourHeight,
              ),
              _buildUsersLines(
                context,
              ),
            ],
          );
        },
      ),
    );
  }

  Column _buildDaysColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        7, // 7 jour de la semaine
        (index) {
          return Column(
            children: [
              // ESPACE POUR LA ZONE ENTETE HEURE
              SizedBox(
                width: widget.dayWidth,
                height: widget.hourHeight,
              ),
              _buildDayLine(
                context,
                widget.weekDays[index],
              ),
            ],
          );
        },
      ),
    );
  }
}
