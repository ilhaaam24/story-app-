import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/location_service.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({Key? key}) : super(key: key);

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isLoadingAddress = false;

  // Default location (Jakarta)
  final LatLng _defaultLocation = const LatLng(-6.200000, 106.816666);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      final location = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = location;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
      await _getAddress(location);
    }
  }

  Future<void> _getAddress(LatLng location) async {
    setState(() {
      _isLoadingAddress = true;
    });

    final address = await _locationService.getAddressFromLatLng(
      location.latitude,
      location.longitude,
    );

    setState(() {
      _selectedAddress = address;
      _isLoadingAddress = false;
    });
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _getAddress(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                context.pop({
                  'lat': _selectedLocation!.latitude,
                  'lng': _selectedLocation!.longitude,
                  'address': _selectedAddress,
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? _defaultLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: _onMapTap,
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation!,
                      infoWindow: InfoWindow(
                        title: 'Selected Location',
                        snippet: _selectedAddress,
                      ),
                    ),
                  }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_isLoadingAddress || _selectedAddress.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isLoadingAddress
                      ? const Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 16),
                            Text('Loading address...'),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Selected Location:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(_selectedAddress),
                          ],
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
