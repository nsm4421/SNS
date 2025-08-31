part of 'create_feed.page.dart';

class CreateFeedScreen extends StatelessWidget {
  const CreateFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Create Feed"),
        elevation: 0,
        actions: const [SubmitButtonWidget()],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: context.read<CreateFeedCubit>().formKey,
          child: const Column(
            children: [
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: FeedPostFragment(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SelectImageFragment(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
