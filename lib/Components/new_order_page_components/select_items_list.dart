import 'package:flutter/material.dart';
import 'package:juice_point/utils/constants.dart';

class SelectedItemsList extends StatefulWidget {
  final Map<String, int> itemCounts;
  final Function(String) onItemIncrement;
  final Function(String) onItemDecrement;
  final Function(String) onItemRemove;
  final BuildContext context;

  const SelectedItemsList({
    super.key,
    required this.itemCounts,
    required this.onItemIncrement,
    required this.onItemDecrement,
    required this.onItemRemove,
    required this.context,
  });

  @override
  SelectedItemsListState createState() => SelectedItemsListState();
}

class SelectedItemsListState extends State<SelectedItemsList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: widget.itemCounts.entries
                    .where((entry) => entry.value >= 1)
                    .map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => widget.onItemDecrement(entry.key),
                          icon: const Icon(
                            Icons.delete,
                            color: red,
                          ),
                        ),
                        Text(entry.value.toString()),
                        IconButton(
                          onPressed: () => widget.onItemIncrement(entry.key),
                          icon: const Icon(
                            Icons.add,
                            color: green,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
