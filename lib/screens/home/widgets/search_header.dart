// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:projeto_estagio/r.dart';
import 'package:projeto_estagio/utils/colors_util.dart';

class SearchHeader extends StatefulWidget {
  SearchHeader(
      {Key? key,
      required this.controller,
      required this.onTapClear,
      required this.onTapSearch,
      required this.onChanged,
      required this.isEmpty})
      : super(key: key);

  final TextEditingController controller;
  final VoidCallback onTapClear;
  final VoidCallback onTapSearch;
  final Function(String) onChanged;
  final bool isEmpty;

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Container(
          width: 165,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(R.assetsPokemonLogo), fit: BoxFit.fill),
          ),
        ),
        Row(
          children: [
            _textField(),
            (widget.isEmpty)
                ? SizedBox(
                    width: 0.1,
                    height: 0.1,
                  )
                : Container(
                    width: 35,
                    height: 35,
                    margin: EdgeInsets.only(left: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        color: ColorsUtil.primaryYellow,
                        child: Padding(
                          padding: EdgeInsets.only(right: 1),
                          child: InkWell(
                            child: Icon(
                              Icons.backspace,
                              size: 25,
                              color: ColorsUtil.searchIcon,
                            ),
                            onTap: widget.onTapClear,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ],
    );
  }

  Container _textField() {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 1, 15, 0),
      height: 50,
      width: (widget.isEmpty) ? 350.9 : 310,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: 0.6,
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
        shape: BoxShape.rectangle,
        color: ColorsUtil.textFieldBackground,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          hintText: "Busque por um pokemon",
          border: InputBorder.none,
          suffixIconConstraints: const BoxConstraints.tightFor(
            width: 35,
            height: 35,
          ),
          suffixIcon: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              color: ColorsUtil.primaryYellow,
              child: Padding(
                padding: EdgeInsets.zero,
                child: InkWell(
                  child: Icon(
                    Icons.search,
                    size: 25,
                    color: ColorsUtil.searchIcon,
                  ),
                  onTap: widget.onTapSearch,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
