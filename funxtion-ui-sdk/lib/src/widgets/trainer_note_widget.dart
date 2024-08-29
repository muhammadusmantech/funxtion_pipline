import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class TrainerNoteWidget extends StatefulWidget {
  final double top;
  final ValueNotifier<bool> isTrainerNotesOpen;
  final String mainNotes, exerciseNotes;
  final void Function() eventsTriggeredFn;

  const TrainerNoteWidget({
    super.key,
    this.top = 10,
    required this.isTrainerNotesOpen,
    required this.eventsTriggeredFn,
    required this.mainNotes,
    required this.exerciseNotes,
  });

  @override
  _TrainerNoteWidgetState createState() => _TrainerNoteWidgetState();
}

class _TrainerNoteWidgetState extends State<TrainerNoteWidget> {
  BorderRadiusGeometry border = BorderRadius.circular(20);
  EdgeInsetsGeometry padding = const EdgeInsets.all(8);
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.top, bottom: 24),
      alignment: Alignment.centerRight,
      child: AnimatedSize(
        alignment: Alignment.centerRight,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: ValueListenableBuilder<bool>(
          valueListenable: widget.isTrainerNotesOpen,
          builder: (_, value, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: padding,
              decoration: BoxDecoration(
                color: AppColor.buttonTertiaryColor,
                borderRadius: border,
              ),
              child: value == false
                  ? InkWell(
                      onTap: () {
                        widget.eventsTriggeredFn();
                        setState(() {
                          padding = const EdgeInsets.all(16);
                          border = BorderRadius.circular(16);
                          widget.isTrainerNotesOpen.value = true;
                        });
                      },
                      child: SvgPicture.asset(AppAssets.personNotesIcon),
                    )
                  : Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.loc.trainerNotesText,
                                style: AppTypography.title14XS
                                    .copyWith(color: AppColor.textPrimaryColor),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    border = BorderRadius.circular(20);
                                    padding = const EdgeInsets.all(6);
                                    widget.isTrainerNotesOpen.value = false;
                                  });
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: AppColor.textPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Text(
                                      widget.mainNotes.trim().isEmpty
                                          ? widget.exerciseNotes
                                          : widget.mainNotes,
                                      style: AppTypography.paragraph14MD
                                          .copyWith(
                                              color: AppColor.textPrimaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
