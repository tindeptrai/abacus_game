import 'package:abacus_game/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../shared/presentation/arg/math_arg.dart';
import '../../../features.dart';
import '../../abacus.dart';
import '../cubit/abacus_cubit.dart';
import '../cubit/abacus_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AbacusScreen extends StatefulWidget {
  final AbacusCubit abacusCubit;

  const AbacusScreen(this.abacusCubit, {super.key});

  @override
  State<AbacusScreen> createState() => _AbacusScreenState();
}

class _AbacusScreenState extends State<AbacusScreen> {
  final abacusCubit = Modular.get<AbacusCubit>();
  late AppLocalizations _localizations;
  bool isFirst = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context)!;
    if (isFirst) {
      isFirst = false;
      final mathArg = ModalRoute.of(context)?.settings.arguments;
      if (mathArg is MathArg) {
        abacusCubit.initData(
          level: mathArg.level,
          operation: mathArg.operator,
          rangeInput: mathArg.numberRange,
          player: mathArg.player,
        );
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget topicWidget(List<BigInt>? numbers) {
    if (numbers == null) return const SizedBox();
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.orange),
      child: ListView.builder(
        itemCount: numbers.length,
        itemBuilder: (_, id) {
          final item = numbers[id];
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: FittedBox(
              child: Text(
                item.toString().numberFormat(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_localizations.sofiAbacusGame),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<AbacusCubit, AbacusState>(
          bloc: abacusCubit,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: FittedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF81C784),
                                  ),
                                  child: Text("Level ${abacusCubit.levelEntities?.level}"),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                            
                                GestureDetector(
                                  onTap: () {
                                    abacusCubit.rePlay();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xFF81C784),
                                    ),
                                    child: const Text("Re-play"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFF81C784),
                              ),
                              child: Text(state.hearts.toString()),
                            ),

                            const SizedBox(
                              width: 8,
                            ),
                            const Icon(Icons.star, size: 40, color: Colors.yellow,)
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 150,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: topicWidget(state.numbers),
                            ),
                            SizedBox(
                              width: 150,
                              child: ButtonCommon(
                                onPressed: () async {
                                  // abacusCubit.convertShapeToNumber();
                                  final (isCorrect, result, userAnswer) = await abacusCubit.checkAnswer();
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ResultPopup(
                                        isCorrect: isCorrect,
                                        correctAnswer: result.toString(),
                                        userAnswer: userAnswer.toString(),
                                        level: abacusCubit.levelEntities?.level.toString() ?? '',
                                        quantityHeart: 1, 
                                        speed: 1,
                                        showSpeed: false,
                                      );

                                    },
                                  );
                                  widget.abacusCubit.resetGame();
                                },
                                label: state.result,
                              ),
                            ),

                          ],
                        ),

                        Expanded(
                          child: HorizontalListWidget(
                            shapes: state.shapes!,
                            abacusCubit: abacusCubit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HorizontalListWidget extends StatefulWidget {
  final List<SquareModel> shapes;
  final AbacusCubit abacusCubit;
  const HorizontalListWidget({super.key, required this.shapes, required this.abacusCubit});

  @override
  State<HorizontalListWidget> createState() => _HorizontalListWidgetState();
}

class _HorizontalListWidgetState extends State<HorizontalListWidget> {

  final PageController _pageController = PageController(viewportFraction: 1 / 5, initialPage: 0);
  int currentIndex = 0;

  void _scrollLeft() {
    print(currentIndex);
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }


  void _scrollRight() {
    print(currentIndex);
    if (currentIndex <= widget.shapes.length - 3) {
      setState(() {
        currentIndex++;
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black)
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          child: PageView.builder(
            padEnds: false,
            controller: _pageController,
            itemCount: widget.shapes.length,
            pageSnapping: true,
            physics: const PageScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.shapes[index];
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  child: SquareWithDiagonals(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.height * 0.2,
                    onLineTap: (line) {},
                    onSelectedLines: (lines) {
                      widget.abacusCubit.onChangeDataInShape(item, index, lines);
                    },
                    initialSelectedLines: item.data,
                  ),
                ),
              );
            },
          ),
        ),
        // const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30,),
              onPressed: _scrollLeft,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward, size: 30,),
              onPressed: _scrollRight,
            ),
          ],
        ),
      ],
    );
  }
}

