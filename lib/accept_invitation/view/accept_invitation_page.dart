import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/accept_invitation/accept_invitation.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';


class AcceptInivitationPage extends StatelessWidget {
  const AcceptInivitationPage({super.key});
 
  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AcceptInvitationBloc(repository: context.read<VhomeRepository>()),
        child: AcceptInivitationPage()
      ),
    );
  }
 
  @override    
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 1000,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SectionTitle(
                      child: Text("Enter invitation code"),
                    ),
                    SizedBox(height: 25),
                    _InvitationField(),
                    SizedBox(height: 25),
                    _ConfirmButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ); 
  }
}

class _InvitationField extends StatelessWidget {
  const _InvitationField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcceptInvitationBloc, AcceptInvitationState>(
      buildWhen: (previous, current) => previous.invitationCode != current.invitationCode,
      builder: (context, state) {
        return StandardFormField(
          hintText: "Invitation code",
          onChanged: (value) => context.read<AcceptInvitationBloc>().add(InvitationCodeChanged(invitationCode: value)),
          errorText: state.invitationCode.displayError != null ? 'invitation code can not be empty' : null,
        );
      }
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    final state = context.select((AcceptInvitationBloc bloc) => bloc.state);

    return state.status.isInProgress
        ? const CircularProgressIndicator()
        : ConfirmButton(
            onPressed: state.isValid
              ? () => context.read<AcceptInvitationBloc>().add(const AcceptInvitationSubmitted())
              : null,
            child: Text("Enter"),
          );
  }
}
