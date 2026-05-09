import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../models/song_model.dart';
import '../services/permission_service.dart';
import '../services/playlist_service.dart';
import '../utils/constants.dart';
import '../widgets/mini_player.dart';
import '../widgets/song_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaylistService _playlistService = PlaylistService();
  final PermissionService _permissionService = PermissionService();

  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Thử load nhạc trực tiếp trước
    try {
      await _loadSongs();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasPermission = true;
        });
      }
      return;
    } catch (_) {}

    // Fallback: xin permission
    _hasPermission = await _permissionService.requestStoragePermission();
    if (_hasPermission) {
      await _permissionService.requestAudioPermission();
      await _loadSongs();
    } else {
      // Force hiện danh sách dù không có permission
      _hasPermission = true;
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadSongs() async {
    try {
      final songs = await _playlistService.getAllSongs();
      if (mounted) {
        setState(() {
          _songs = songs;
          _filteredSongs = songs;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải nhạc: $e')),
        );
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = _songs;
      } else {
        _filteredSongs = _songs.where((s) {
          return s.title.toLowerCase().contains(query.toLowerCase()) ||
              s.artist.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            if (_isSearching) _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary))
                  : !_hasPermission
                      ? _buildPermissionDenied()
                      : _filteredSongs.isEmpty
                          ? _buildEmpty()
                          : _buildSongList(),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Nhạc của tôi',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.search_off : Icons.search,
                  color: AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      _filteredSongs = _songs;
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.white),
                onPressed: _loadSongs,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm bài hát, nghệ sĩ...',
          hintStyle: const TextStyle(color: AppColors.grey),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: _onSearch,
      ),
    );
  }

  Widget _buildSongList() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadSongs,
      child: ListView.builder(
        itemCount: _filteredSongs.length,
        itemBuilder: (context, index) {
          final song = _filteredSongs[index];
          final provider = context.watch<AudioProvider>();
          final isPlaying = provider.currentSong?.id == song.id;

          return SongTile(
            song: song,
            isPlaying: isPlaying,
            onTap: () {
              context.read<AudioProvider>().setPlaylist(_filteredSongs, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_off, size: 80, color: AppColors.grey),
            const SizedBox(height: 20),
            const Text('Cần quyền truy cập bộ nhớ',
                style: TextStyle(color: AppColors.white, fontSize: 20)),
            const SizedBox(height: 10),
            const Text(
              'Vui lòng cấp quyền để truy cập nhạc trên thiết bị',
              style: TextStyle(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              onPressed: _initializeApp,
              child: const Text('Cấp quyền',
                  style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_note, size: 80, color: AppColors.grey),
          const SizedBox(height: 20),
          const Text('Không tìm thấy bài hát',
              style: TextStyle(color: AppColors.white, fontSize: 20)),
          const SizedBox(height: 10),
          const Text('Thêm file nhạc vào thiết bị và thử lại',
              style: TextStyle(color: AppColors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: _loadSongs,
            child: const Text('Tải lại',
                style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}