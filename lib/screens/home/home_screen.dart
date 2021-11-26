// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projeto_estagio/controller/pokelist_store.dart';
import 'package:projeto_estagio/model/details_model.dart';
import 'package:projeto_estagio/screens/home/widgets/search_header.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_estagio/utils/colors_util.dart';
import 'package:projeto_estagio/utils/func_util.dart';
import 'package:projeto_estagio/widgets/loading_widget.dart';
import 'package:projeto_estagio/widgets/type_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokeListStore _pokeStore = PokeListStore();
  final TextEditingController _textEditingController = TextEditingController();
  final snackBar = SnackBar(
    content: Text('Nome muito pequeno'),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Desfazer',
      textColor: ColorsUtil.primaryYellow,
      onPressed: () {},
    ),
  );

  @override
  void initState() {
    super.initState();
    if (_pokeStore.pokeUrl == null) {
      _pokeStore.fetchPokemonUrl(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.appBackground,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      color: ColorsUtil.appBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Observer(
              builder: (BuildContext context) {
                return SearchHeader(
                    controller: _textEditingController,
                    onChanged: _pokeStore.onChangedText,
                    isEmpty: _pokeStore.isEmpty,
                    onTapClear: () =>
                        _pokeStore.onTapClear(_textEditingController),
                    onTapSearch: () {
                      _pokeStore.onTapSearch(snackBar);
                      if (!_pokeStore.isSearchValid) {
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    });
              },
            ),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Observer _buildList() {
    return Observer(builder: (BuildContext context) {
      return (_pokeStore.pokeUrl != null && _pokeStore.listPokemon.isNotEmpty)
          ? GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 151 / 107,
                mainAxisSpacing: 19,
                crossAxisSpacing: 19,
                crossAxisCount: 2,
              ),
              itemCount: _pokeStore.setItemCount(),
              itemBuilder: (context, index) {
                return _setScreen(index);
              })
          : Loading();
    });
  }

  Widget _setScreen(int index) {
    if (index == _pokeStore.listPokemon.length &&
        _pokeStore.listPokemon.length < 800) {
      _pokeStore.setOffset();
      return Loading();
    }
    // Details? details = _pokeStore.listPokemon[index];
    // if (_pokeStore.isSearching) {
    //   details = _pokeStore.pokeDetail;
    // } else {
    //   details = _pokeStore.listPokemon[index];
    // }
    Details? details = _pokeStore.setDetail(index);

    return _card(details, details?.name, details!.types[0].type.name);
  }

  Container _card(Details? details, String? pokemonName, String typeName) {
    final typeColor = ColorsUtil.getColorByType(type: typeName);
    return Container(
      padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
      decoration: BoxDecoration(
          color: typeColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: typeColor.withOpacity(0.6),
              spreadRadius: 0.1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ]),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FuncUtil.capitalize('$pokemonName'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 14,
              ),
              TypeWidget(typeName: typeName),
            ],
          ),
          Positioned(
            top: 5,
            right: -11,
            child: CachedNetworkImage(
              imageUrl: details!.sprites!.other!.officialArtwork.frontDefault,
              alignment: Alignment.topRight,
              fit: BoxFit.cover,
              width: 81,
              height: 81,
            ),
          ),
        ],
      ),
    );
  }
}
