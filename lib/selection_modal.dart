import 'package:flutter/material.dart';

class SelectionModal extends StatefulWidget {
  @override
  _SelectionModalState createState() => _SelectionModalState();

  final List<Map<String, dynamic>> dataSource;
  final List<dynamic> values;
  final bool filterable;
  final String textField;
  final String valueField;
  final String title;
  final int? maxLength;
  final String? maxLengthText;
  final Color? buttonBarColor;
  final String? cancelButtonText;
  final IconData? cancelButtonIcon;
  final Color? cancelButtonColor;
  final Color? cancelButtonTextColor;
  final String? saveButtonText;
  final IconData? saveButtonIcon;
  final Color? saveButtonColor;
  final Color? saveButtonTextColor;
  final String? clearButtonText;
  final IconData? clearButtonIcon;
  final Color? clearButtonColor;
  final Color? clearButtonTextColor;
  final String? deleteButtonTooltipText;
  final IconData? deleteIcon;
  final Color? deleteIconColor;
  final Color? selectedOptionsBoxColor;
  final String? selectedOptionsInfoText;
  final Color? selectedOptionsInfoTextColor;
  final IconData? checkedIcon;
  final IconData? uncheckedIcon;
  final Color? checkBoxColor;
  final Color? searchBoxColor;
  final String? searchBoxHintText;
  final Color? searchBoxFillColor;
  final Color? searchBoxTextColor;
  final IconData? searchBoxIcon;
  final String? searchBoxToolTipText;

  SelectionModal({
    this.filterable = true,
    this.dataSource = const [],
    this.title = 'Please select one or more option(s)',
    this.values = const [],
    this.textField = 'text',
    this.valueField = 'value',
    this.maxLength,
    this.maxLengthText,
    this.buttonBarColor,
    this.cancelButtonText,
    this.cancelButtonIcon,
    this.cancelButtonColor,
    this.cancelButtonTextColor,
    this.saveButtonText,
    this.saveButtonIcon,
    this.saveButtonColor,
    this.saveButtonTextColor,
    this.clearButtonText,
    this.clearButtonIcon,
    this.clearButtonColor,
    this.clearButtonTextColor,
    this.deleteButtonTooltipText,
    this.deleteIcon,
    this.deleteIconColor,
    this.selectedOptionsBoxColor,
    this.selectedOptionsInfoText,
    this.selectedOptionsInfoTextColor,
    this.checkedIcon,
    this.uncheckedIcon,
    this.checkBoxColor,
    this.searchBoxColor,
    this.searchBoxHintText,
    this.searchBoxFillColor,
    this.searchBoxTextColor,
    this.searchBoxIcon,
    this.searchBoxToolTipText,
  });
}

class _SelectionModalState extends State<SelectionModal> {
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  List<Map<String, dynamic>> _localDataSourceWithState = [];
  List<Map<String, dynamic>> _searchresult = [];

  _SelectionModalState() {
    _controller.addListener(() {
      setState(() {
        _isSearching = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDataSourceWithState();
  }

  void _initializeDataSourceWithState() {
    widget.dataSource.forEach((item) {
      var newItem = {
        'value': item[widget.valueField],
        'text': item[widget.textField],
        'checked': widget.values.contains(item[widget.valueField]),
      };
      _localDataSourceWithState.add(newItem);
    });
    _searchresult = List.from(_localDataSourceWithState);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Container(),
      elevation: 0.0,
      title: Center(child: Text(widget.title, style: TextStyle(fontSize: 16.0))),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close, size: 26.0),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          widget.filterable ? _buildSearchText() : SizedBox.shrink(),
          Expanded(child: _optionsList()),
          _currentlySelectedOptions(),
          Container(
            color: widget.buttonBarColor ?? Colors.grey.shade600,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildButton(
                  text: widget.cancelButtonText ?? 'Cancel',
                  icon: widget.cancelButtonIcon ?? Icons.clear,
                  color: widget.cancelButtonColor ?? Colors.grey.shade100,
                  textColor: widget.cancelButtonTextColor ?? Colors.black87,
                  onPressed: () => Navigator.pop(context, null),
                ),
                _buildButton(
                  text: widget.clearButtonText ?? 'Clear All',
                  icon: widget.clearButtonIcon ?? Icons.clear_all,
                  color: widget.clearButtonColor ?? Colors.black,
                  textColor: widget.clearButtonTextColor ?? Colors.white,
                  onPressed: _clearSelection,
                ),
                _buildButton(
                  text: widget.saveButtonText ?? 'Save',
                  icon: widget.saveButtonIcon ?? Icons.save,
                  color: widget.saveButtonColor ?? Theme.of(context).colorScheme.primary,
                  textColor: widget.saveButtonTextColor ?? Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    final selectedValues = _localDataSourceWithState
                        .where((item) => item['checked'] == true)
                        .map((item) => item['value'])
                        .toList();
                    Navigator.pop(context, selectedValues);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ElevatedButton _buildButton({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      label: Text(text),
      icon: Icon(icon, size: 20.0),
      style: ElevatedButton.styleFrom(foregroundColor: textColor, backgroundColor: color),
      onPressed: onPressed,
    );
  }

  Widget _currentlySelectedOptions() {
    final selectedOptions = _localDataSourceWithState
        .where((item) => item['checked'] == true)
        .map((item) => Chip(
      label: Text(item['text'] ?? ''),
      deleteIcon: Icon(widget.deleteIcon ?? Icons.cancel),
      deleteIconColor: widget.deleteIconColor ?? Colors.grey,
      onDeleted: () {
        setState(() {
          item['checked'] = false;
        });
      },
    ))
        .toList();

    return selectedOptions.isNotEmpty
        ? Container(
      padding: EdgeInsets.all(10.0),
      color: widget.selectedOptionsBoxColor ?? Colors.grey.shade400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            (widget.maxLength != null
                ? '${widget.maxLengthText ?? 'Maximum ${widget.maxLength} items'}\n'
                : '') +
                (widget.selectedOptionsInfoText ?? 'Currently selected ${selectedOptions.length} items (tap to remove)'),
            style: TextStyle(
              color: widget.selectedOptionsInfoTextColor ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.start,
            children: selectedOptions,
          ),
        ],
      ),
    )
        : Container();
  }

  ListView _optionsList() {
    return ListView(
      children: _searchresult.map((item) {
        return ListTile(
          title: Text(item['text'] ?? ''),
          leading: Transform.scale(
            scale: 1.5,
            child: Icon(
              item['checked'] ? widget.checkedIcon ?? Icons.check_box : widget.uncheckedIcon ?? Icons.check_box_outline_blank,
              color: widget.checkBoxColor ?? Theme.of(context).primaryColor,
            ),
          ),
          onTap: () {
            setState(() {
              item['checked'] = !item['checked'];
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSearchText() {
    return Container(
      color: widget.searchBoxColor ?? Theme.of(context).primaryColor,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: TextField(
        controller: _controller,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: widget.searchBoxTextColor ?? Colors.black87),
        decoration: InputDecoration(
          hintText: widget.searchBoxHintText ?? "Search...",
          fillColor: widget.searchBoxFillColor ?? Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(widget.searchBoxIcon ?? Icons.clear),
            onPressed: () {
              _controller.clear();
              searchOperation('');
            },
          ),
        ),
        onChanged: searchOperation,
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      _localDataSourceWithState = _localDataSourceWithState.map((item) {
        item['checked'] = false;
        return item;
      }).toList();
    });
  }

  void searchOperation(String searchText) {
    setState(() {
      _searchresult = _localDataSourceWithState
          .where((item) => '${item['value']} ${item['text']}'.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
