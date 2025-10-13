part of 'p_create_post.dart';

class _CreatePostScreen extends StatelessWidget {
  const _CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("CREATE POST")),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12, top: 24),
                child: _ContentFragment(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12, top: 36),
                child: _MediaFragment(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const _SubmitButtonWidget(),
    );
  }
}
