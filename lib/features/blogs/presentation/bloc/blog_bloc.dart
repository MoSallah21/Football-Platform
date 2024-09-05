import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/strings/failures.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/blogs/domain/usecases/get_all_blogs.dart';

part 'blog_event.dart';
part 'blog_state.dart';
class BlogBloc extends Bloc<BlogEvent,BlogState> {
  static BlogBloc get(context) => BlocProvider.of(context);

  final GetAllBlogsUseCase getAllBlogs;

  BlogBloc({required this.getAllBlogs}) :super(BlogInitState()) {
    on<GetAllBlogsEvent>((event, emit) async {
      emit(GetAllBlogsLoadingState());

      final failureOrPosts = await getAllBlogs.call();

      failureOrPosts.fold(
            (failure) =>
          emit(GetAllBlogsErrorState(message: _mapFailureToMessage(failure)))
        ,
            (blogs)=>
          emit(GetAllBlogsSuccessState(blogs: blogs))
        ,
      );
    });  }

}
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OffLineFailure:
        return OFF_LINE_FAILURE_MESSAGE;
      default:
        return "Unexpected error, please try again later";
    }
  }

