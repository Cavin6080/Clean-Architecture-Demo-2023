import 'package:clean_architecture/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:clean_architecture/number_trivia/presentation/widgets/message_display_widget.dart';
import 'package:clean_architecture/number_trivia/presentation/widgets/trivia_controlls.dart';
import 'package:clean_architecture/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) =>
      BlocProvider(
        create: (_) => getIt<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                // Top half
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return MessageDisplay(
                        message: 'Start searching!',
                      );
                    } else if (state is Loading) {
                      return const LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else if (state is Error) {
                      return MessageDisplay(message: state.message);
                    }
                    return MessageDisplay(
                      message: '',
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const TriviaControls()
              ],
            ),
          ),
        ),
      );
}
