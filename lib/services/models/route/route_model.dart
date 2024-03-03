class RouteModel{

  final int routeId;
  final int driverRouteId;
  final String routeTitle;

  const RouteModel({required this.routeId, required this.driverRouteId, required this.routeTitle});

  factory RouteModel.fromJson(Map<String, dynamic> route){

  return RouteModel(routeId: route['route_id'], driverRouteId: route['driver_route_id'], routeTitle: route['route_name']);
  }
}