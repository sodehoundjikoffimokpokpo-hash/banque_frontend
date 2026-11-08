import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(
  const MaterialApp(
    home: TableauDeBordBancaire(),
    debugShowCheckedModeBanner: false,
  ),
);

class TableauDeBordBancaire extends StatefulWidget {
  const TableauDeBordBancaire({super.key});

  @override
  State<TableauDeBordBancaire> createState() => _TableauDeBordBancaireState();
}

class _TableauDeBordBancaireState extends State<TableauDeBordBancaire> {
  // Le nom de la variable a été changé pour éviter l'accent 'é'
  late Future<Map<String, dynamic>> _donneesBanqueFuture;

  // Le nom de la fonction est devenu 'recupererDonneesBanque' (sans accent)
  Future<Map<String, dynamic>> recupererDonneesBanque() async {
    final url = Uri.parse('http://localhost:8085/api/comptes/TG777');
    final reponse = await http.get(url);

    if (reponse.statusCode == 200) {
      return jsonDecode(reponse.body);
    } else {
      throw Exception('Compte introuvable');
    }
  }

  @override
  void initState() {
    super.initState();
    _donneesBanqueFuture = recupererDonneesBanque();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          'IAEC Digital Bank',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F2C59),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _donneesBanqueFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'Erreur réseau ou aucun compte trouvé.\nAvez-vous injecté le compte de test TG777 ?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final compte = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ravi de vous revoir, ${compte['titulaire'] ?? 'Client'}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2C59),
                  ),
                ),
                const SizedBox(height: 20),

                // --- CARTE BANCAIRE VISUELLE ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F2C59), Color(0xFF3F72AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SOLDE DISPONIBLE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${compte['solde'] ?? 0} F CFA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'N° COMPTE : ${compte['numeroCompte'] ?? compte['numero_compte'] ?? 'Inconnu'}',
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
