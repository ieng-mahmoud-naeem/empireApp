import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropSearch extends StatefulWidget {
  const CustomDropSearch(
      {super.key,
      required this.text,
      required this.onChanged,
      required this.selectedItems,
      required this.getUserInfoList,
      required this.width});
  final String text;
  final Function(String?)? onChanged;
  final List<String> selectedItems;
  final List<String> getUserInfoList;
  final double? width;
  @override
  State<CustomDropSearch> createState() => _CustomDropSearchState();
}

class _CustomDropSearchState extends State<CustomDropSearch> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        barrierColor: Colors.white,
        isExpanded: true,
        hint: Text(
          widget.text,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: widget.getUserInfoList.map((item) {
          return DropdownMenuItem(
            value: item,
            //disable default onTap to avoid closing menu when selecting an item
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final isSelected = widget.selectedItems.contains(item);
                return InkWell(
                  onTap: () {
                    isSelected
                        ? widget.selectedItems.remove(item)
                        : widget.selectedItems.add(item);
                    //This rebuilds the StatefulWidget to update the button's text
                    setState(() {});
                    //This rebuilds the dropdownMenu Widget to update the check mark
                    menuSetState(() {});
                  },
                  child: Container(
                    color: Colors.white,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check_box_outlined)
                        else
                          const Icon(Icons.check_box_outline_blank),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
        //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
        value: widget.selectedItems.isEmpty ? null : widget.selectedItems.last,
        onChanged: widget.onChanged,
        selectedItemBuilder: (context) {
          return widget.getUserInfoList.map(
            (item) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                  widget.selectedItems.join(', '),
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              );
            },
          ).toList();
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.only(left: 16, right: 8),
          height: 40,
          width: widget.width,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 60,
          padding: EdgeInsets.zero,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: textEditingController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'search',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().contains(searchValue);
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }
}
