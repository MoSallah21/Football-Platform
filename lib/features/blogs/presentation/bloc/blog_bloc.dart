import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/strings/failures.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/blogs/domain/usecases/get_all_blogs.dart';
import 'package:rxdart/rxdart.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  static BlogBloc get(context) => BlocProvider.of(context);

  final GetAllBlogsUseCase getAllBlogs;

  // Cache for blogs to avoid repeated API calls
  List<Blog>? _cachedBlogs;
  DateTime? _lastFetchTime;

  // Cache duration (5 minutes)
  static const Duration _cacheDuration = Duration(minutes: 5);

  // Debounce timer to prevent rapid consecutive calls
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  BlogBloc({required this.getAllBlogs}) : super(BlogInitState()) {
    // Use transformer to handle concurrent events efficiently
    on<GetAllBlogsEvent>(
      _onGetAllBlogsEvent,
      transformer: _debounceSequential(_debounceDuration),
    );
    on<RefreshBlogsEvent>(
      _onRefreshBlogsEvent,
      transformer: _throttle(_debounceDuration),
    );
  }

  // Debounce transformer to prevent rapid fire events
  EventTransformer<E> _debounceSequential<E>(Duration duration) {
    return (events, mapper) {
      return events
          .debounceTime(duration)
          .asyncExpand(mapper);
    };
  }

  // Throttle transformer for refresh events
  EventTransformer<E> _throttle<E>(Duration duration) {
    return (events, mapper) {
      return events
          .throttleTime(duration)
          .asyncExpand(mapper);
    };
  }

  Future<void> _onGetAllBlogsEvent(
      GetAllBlogsEvent event,
      Emitter<BlogState> emit,
      ) async {
    // Return cached data immediately if valid
    if (_cachedBlogs != null && _isCacheValid()) {
      emit(GetAllBlogsSuccessState(blogs: _cachedBlogs!));
      return;
    }

    // Only show loading if we don't have cached data
    if (_cachedBlogs == null || _cachedBlogs!.isEmpty) {
      emit(GetAllBlogsLoadingState());
    }

    await _fetchBlogs(emit);
  }

  Future<void> _onRefreshBlogsEvent(
      RefreshBlogsEvent event,
      Emitter<BlogState> emit,
      ) async {
    // Keep showing cached data during refresh
    if (_cachedBlogs != null && _cachedBlogs!.isNotEmpty) {
      emit(GetAllBlogsSuccessState(blogs: _cachedBlogs!));
    } else {
      emit(GetAllBlogsLoadingState());
    }

    // Clear cache to force fresh data
    _clearCache();
    await _fetchBlogs(emit);
  }

  Future<void> _fetchBlogs(Emitter<BlogState> emit) async {
    try {
      final failureOrPosts = await getAllBlogs.call();

      failureOrPosts.fold(
            (failure) {
          // Always prefer cached data over error
          if (_cachedBlogs != null && _cachedBlogs!.isNotEmpty) {
            emit(GetAllBlogsSuccessState(blogs: _cachedBlogs!));
          } else {
            emit(GetAllBlogsErrorState(message: _mapFailureToMessage(failure)));
          }
        },
            (blogs) {
          // Only update cache if data is non-empty
          if (blogs.isNotEmpty) {
            _cachedBlogs = blogs;
            _lastFetchTime = DateTime.now();
          }
          emit(GetAllBlogsSuccessState(blogs: blogs));
        },
      );
    } catch (e) {
      // Graceful degradation: show cached data on error
      if (_cachedBlogs != null && _cachedBlogs!.isNotEmpty) {
        emit(GetAllBlogsSuccessState(blogs: _cachedBlogs!));
      } else {
        emit(GetAllBlogsErrorState(message: 'حدث خطأ غير متوقع'));
      }
    }
  }

  bool _isCacheValid() {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  void _clearCache() {
    _cachedBlogs = null;
    _lastFetchTime = null;
  }

  // Optimized error message mapping using const map
  static const Map<Type, String> _failureMessages = {
    ServerFailure: SERVER_FAILURE_MESSAGE,
    EmptyCacheFailure: EMPTY_CACHE_FAILURE_MESSAGE,
    OffLineFailure: OFF_LINE_FAILURE_MESSAGE,
  };

  String _mapFailureToMessage(Failure failure) {
    return _failureMessages[failure.runtimeType] ??
        "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى";
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _clearCache();
    return super.close();
  }
}