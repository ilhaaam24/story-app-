import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/auth_provider.dart';
import '../../data/repositories/story_repository.dart';
import '../../data/models/story_model.dart';
import '../../core/utils/location_service.dart';

class StoryDetailPage extends StatefulWidget {
  final String storyId;

  const StoryDetailPage({
    Key? key,
    required this.storyId,
  }) : super(key: key);

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  final StoryRepository _storyRepository = StoryRepository();
  final LocationService _locationService = LocationService();
  StoryModel? _story;
  bool _isLoading = true;
  String? _errorMessage;
  String _locationAddress = '';

  @override
  void initState() {
    super.initState();
    _loadStoryDetail();
  }

  Future<void> _loadStoryDetail() async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;

    if (token == null) return;

    try {
      final story = await _storyRepository.getStoryDetail(token, widget.storyId);
      
      if (story.lat != null && story.lon != null) {
        final address = await _locationService.getAddressFromLatLng(
          story.lat!,
          story.lon!,
        );
        setState(() {
          _locationAddress = address;
        });
      }

      setState(() {
        _story = story;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Detail'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _story == null
                  ? const Center(child: Text('Story not found'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Hero(
                            tag: 'story-${_story!.id}',
                            child: CachedNetworkImage(
                              imageUrl: _story!.photoUrl,
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Author & Date
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(_story!.name[0].toUpperCase()),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _story!.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            _formatDate(_story!.createdAt),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Description
                                Text(
                                  _story!.description,
                                  style: const TextStyle(fontSize: 14),
                                ),

                                // Location Map
                                if (_story!.lat != null && _story!.lon != null) ...[
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (_locationAddress.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              _locationAddress,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: 200,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            _story!.lat!,
                                            _story!.lon!,
                                          ),
                                          zoom: 15,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId('story'),
                                            position: LatLng(
                                              _story!.lat!,
                                              _story!.lon!,
                                            ),
                                            infoWindow: InfoWindow(
                                              title: _story!.name,
                                              snippet: _locationAddress,
                                            ),
                                          ),
                                        },
                                        zoomControlsEnabled: false,
                                        myLocationButtonEnabled: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
