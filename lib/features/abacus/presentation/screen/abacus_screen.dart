import 'dart:ffi';

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
import 'dart:math';

/// Model chứa thông tin về topic
class TopicModel {
   final BigInt id;
   bool isHighlight;

  TopicModel({
    required this.id,
    required this.isHighlight,
  });
}

/// Constants cho UI
class AbacusScreenConstants {
  static const double horizontalPadding = 12.0;
  static const double verticalSpacing = 16.0;
  static const double smallSpacing = 4.0;
  static const double mediumSpacing = 8.0;
  static const double topicWidthRatio = 0.15;
  static const double topicHeightRatio = 0.5;
  static const double horizontalListHeightRatio = 0.5;
  static const double horizontalListWidthRatio = 0.5;
  static const double horizontalListItemHeightRatio = 0.3;
  static const double infoContainerPadding = 16.0;
  static const double borderRadius = 8.0;
  static const Color infoContainerColor = Color(0xFF81C784);
}

/// Widget chính cho màn hình Abacus
class AbacusScreen extends StatefulWidget {
  const AbacusScreen({super.key});

  @override
  State<AbacusScreen> createState() => _AbacusScreenState();
}

class _AbacusScreenState extends State<AbacusScreen> {
  late AbacusCubit _abacusCubit;
  late AppLocalizations _localizations;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _abacusCubit = Modular.get<AbacusCubit>();
    _setLandscapeOrientation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context)!;
    _initializeData();
  }

  @override
  void dispose() {
    _setPortraitOrientation();
    super.dispose();
  }

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _setPortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _initializeData() {
    if (!_isFirst) return;
    
    _isFirst = false;
    final mathArg = ModalRoute.of(context)?.settings.arguments;
    if (mathArg is MathArg) {
      _abacusCubit.initData(
        level: mathArg.level,
        operation: mathArg.operator,
        rangeInput: mathArg.numberRange,
        player: mathArg.player,
      );
    }
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
          bloc: _abacusCubit,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AbacusScreenConstants.horizontalPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AbacusHeader(
                      state: state,
                      abacusCubit: _abacusCubit,
                      onCheckAnswer: _handleCheckAnswer,
                    ),
                    const SizedBox(height: AbacusScreenConstants.verticalSpacing),
                    _AbacusContent(
                      state: state,
                      abacusCubit: _abacusCubit,
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

  Future<void> _handleCheckAnswer(AbacusState state) async {
    final (isCorrect, result, userAnswer) = await _abacusCubit.checkAnswer();
    
    if (!mounted) return;
    
    await showDialog(
      context: context,
      builder: (context) => ResultPopup(
        isCorrect: isCorrect,
        correctAnswer: result.toString(),
        userAnswer: userAnswer.toString(),
        level: _abacusCubit.levelEntities?.level.toString() ?? '',
        quantityHeart: 1,
        speed: 1,
        showSpeed: false,
      ),
    );
    
    _abacusCubit.rePlay();
  }
}

/// Widget header chứa thông tin level, replay button, result và hearts
class _AbacusHeader extends StatelessWidget {
  final AbacusState state;
  final AbacusCubit abacusCubit;
  final Function(AbacusState) onCheckAnswer;

  const _AbacusHeader({
    required this.state,
    required this.abacusCubit,
    required this.onCheckAnswer,
  });

  Widget _buildInfoContainer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AbacusScreenConstants.infoContainerPadding,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AbacusScreenConstants.borderRadius),
        color: AbacusScreenConstants.infoContainerColor,
      ),
      child: Text(text,),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = state.index;
    return IntrinsicHeight(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoContainer("Level ${abacusCubit.levelEntities?.level}"),
          const SizedBox(width: AbacusScreenConstants.smallSpacing),
          GestureDetector(
            onTap: abacusCubit.rePlay,
            child: _buildInfoContainer("Re-play"),
          ),
          const SizedBox(width: AbacusScreenConstants.smallSpacing),
          Expanded(
            child: GestureDetector(
              onTap: () => onCheckAnswer(state),
              child: Container(
                      padding: const EdgeInsets.symmetric(
              horizontal: AbacusScreenConstants.infoContainerPadding,
              vertical: 12,
            ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AbacusScreenConstants.borderRadius),
                  color:  Colors.teal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.result.numberFormat().length,
                        (index) {
                      final page = currentIndex;
                      final numberWithoutComma = state.result.numberFormat().replaceAll(',', '');
                      final start = page.round();
                      final end = (start + (5).round() - 1).clamp(0, numberWithoutComma.length - 1);
                      
                      // Đếm số dấu phẩy trước vị trí hiện tại để điều chỉnh index
                      int commaCount = 0;
                      for (int i = 0; i < index; i++) {
                        if (state.result.numberFormat()[i] == ',') {
                          commaCount++;
                        }
                      }
                      
                      final adjustedIndex = index - commaCount;
                      final isActive = adjustedIndex >= start && adjustedIndex <= end && state.result.numberFormat()[index] != ',';
                      
                      return Text(
                        state.result.numberFormat()[index],
                        style: TextStyle(
                          color: isActive ? Colors.orange : Colors.white,
                          fontSize: 24,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AbacusScreenConstants.infoContainerPadding,
                  vertical: 18,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AbacusScreenConstants.borderRadius),
                  color: AbacusScreenConstants.infoContainerColor,
                ),
                child: Text(state.hearts.toString()),
              ),
              const SizedBox(width: AbacusScreenConstants.mediumSpacing),
              const Icon(
                Icons.star,
                size: 40,
                color: Colors.yellow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// / Widget content chứa topic widget và horizontal list
class _AbacusContent extends StatelessWidget {
  final AbacusState state;
  final AbacusCubit abacusCubit;

  const _AbacusContent({
    required this.state,
    required this.abacusCubit,
  });

  // / Hàm xác định các index số cần làm nổi bật (đã sáng thì không tắt)
  List<TopicModel> getHighlightIndexes(List<TopicModel> numbers, String resultStr) {
    BigInt? result;
    numbers[0].isHighlight = true;
    try {
      result = BigInt.parse(resultStr.replaceAll(',', ''));
    } catch (_) {
      return numbers;
    }
    BigInt sum = BigInt.zero;
    for (int i = 0; i < numbers.length; i++) {
      if (numbers[i].isHighlight) {
        sum += numbers[i].id;
      }
      if (result == sum) {
        if (i + 1 < numbers.length) {
          numbers[i + 1].isHighlight = true;
        } else {
          return numbers;
        }
      }
    }
    return numbers;
  }




  Widget _buildTopicWidget(List<TopicModel>? numbers, BuildContext context, int highlightIndex) {
    if (numbers == null) return const SizedBox.shrink();
      numbers = getHighlightIndexes(numbers, state.result);
    // Sử dụng hàm mới để lấy danh sách index cần sáng
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AbacusScreenConstants.borderRadius),
        color: Colors.orange,
      ),
      child: ListView.builder(
        itemCount: numbers.length,
        itemBuilder: (_, index) {
          final item = numbers![index];
          final isHighlight = item.isHighlight;
          return  Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AbacusScreenConstants.borderRadius),
              color: isHighlight ? Colors.teal : null,
            ),
            height: ((MediaQuery.of(context).size.height - 16 - 12 *5) * 0.1),
            child: FittedBox(
              child: Text(
                item.id.toString().numberFormat(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: isHighlight ? Colors.white : Colors.black,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Không cần lấy highlightIndex đơn lẻ nữa
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * AbacusScreenConstants.topicWidthRatio,
          height: MediaQuery.of(context).size.height * AbacusScreenConstants.topicHeightRatio,
          child: _buildTopicWidget(state.numbers, context, 0),
        ),
        Expanded(
          child: HorizontalListWidget(
            shapes: state.shapes!,
            abacusCubit: abacusCubit,
          ),
        ),
      ],
    );
  }
}

/// Widget horizontal list với PageView
class HorizontalListWidget extends StatefulWidget {
  final List<SquareModel> shapes;
  final AbacusCubit abacusCubit;

  const HorizontalListWidget({
    super.key,
    required this.shapes,
    required this.abacusCubit,
  });

  @override
  State<HorizontalListWidget> createState() => _HorizontalListWidgetState();
}

class _HorizontalListWidgetState extends State<HorizontalListWidget> {
  static const double _viewportFraction = 1 / 5;
  static const double _containerPadding = 8.0;

  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: _viewportFraction,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  Widget _buildPageViewContainer() {
    final width = MediaQuery.of(context).size.width * 0.5 / 5;
    final height = MediaQuery.of(context).size.height * 0.3;
    
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: _containerPadding),
      margin: const EdgeInsets.symmetric(horizontal: _containerPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AbacusScreenConstants.borderRadius),
        border: Border.all(color: Colors.black),
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
            _currentIndex = index;
          });
          widget.abacusCubit.onChangeIndex(index);
        },
        itemBuilder: (context, index) {
          final item = widget.shapes[index];
          return Center(
            child: SquareWithDiagonals(
              height: height,
              width: width,
              onLineTap: (_) {},
              onSelectedLines: (lines) {
                widget.abacusCubit.onChangeDataInShape(item, index, lines);
              },
              initialSelectedLines: item.data,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPageViewContainer(),
      ],
    );
  }
}

