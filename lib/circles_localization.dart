import "package:circles_app/presentation/common/platform_alerts.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";

import "cupertinoLocalizationDelegate.dart";

final localizationsDelegates = <LocalizationsDelegate>[
  const CirclesLocalizationsDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  const FallbackCupertinoLocalisationsDelegate()
];

class CirclesLocalizations {
  CirclesLocalizations(this.locale);

  final Locale locale;

  static CirclesLocalizations of(BuildContext context) {
    return Localizations.of<CirclesLocalizations>(
        context, CirclesLocalizations);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    "en": {
      "log_out": "Log out",
      "log_in": "Log in",
      "hello_name": "Hello {name}!",
      "login_fail_user_not_found": "Login failed. No such user exists.",
      "login_fail": "Login failed. Code: '{code}'",
      "calendar_title": "Calendar",
      "calendar_text_today": "Today:",
      "calendar_text_all_day": "all day",
      "channel_join": "Join Topic",
      "channel_join_message": "Join the topic to send messages.",
      "channel_joined_postfix_message": "joined channel",
      "channel_joined_event_postfix_message": "joined event",
      "channel_left_postfix_message": "left channel",
      "channel_left_event_postfix_message": "left event",
      "channel_leave_alert_title": "Leave channel",
      "channel_leave_alert_message": "Do you really want to leave?",
      "channel_create_title": "Create Topic",
      "channel_create_button": "Create",
      "channel_input_hint": "Message",
      "channel_input_send": "Send",
      "channel_title": "Topics",
      "channel_list_pending": "UNJOINED",
      "channel_list_joined": "JOINED",
      "channel_list_previous": "PREVIOUS",
      "channel_list_upcoming": "UPCOMING",
      "channel_list_events": "Events",
      "channel_list_unread": "Unread",
      "channel_form_topic_name": "Enter topic name",
      "channel_form_topic_description": "Enter purpose (optional)",
      "channel_form_topic_description_helper":
          "Briefly describe the purpose of this channel",
      "channel_form_create_topic": "Create Topic",
      "channel_form_create_topic_empty_error": "Maximum 30 characters",
      "channel_form_create_topic_exists_error": "This topic already exists.",
      "channel_form_create_topic_public": "Open",
      "channel_form_create_topic_private": "Private",
      "channel_form_create_topic_public_helper":
          "Everyone in this group can join",
      "channel_form_create_topic_private_helper":
          "Invite group members to this topic:",
      "channel_form_topic_exists":
          "There already exists a topic with this name.",
      "channel_form_select_members_error": "Please select at least one member.",
      "channel_form_select_members":
          "Select the members who can join the topic:",
      "channel_invite_title": "Invite more members",
      "channel_invite_button": "Add more members",
      "channel_rsvp_yes_postfix": "is going",
      "channel_rsvp_no_postfix": "is not going",
      "channel_rsvp_maybe_postfix": "is maybe going",
      "attach_modal_title": "Attach Picture",
      "attach_modal_subtitle": "Select from",
      "attach_modal_camera": "Camera",
      "attach_modal_gallery": "Photo Library",
      "attach_error": "Error attaching picture",
      "generic_soon_alert_title": "We are working on it",
      "generic_soon_alert_message":
          "This functionality will be available soon.",
      "generic_yes": "Yes",
      "generic_cancel": "Cancel",
      "generic_next": "Next",
      "generic_ok": "OK",
      "generic_back": "Back",
      "generic_at": "at",
      "generic_you": "You",
      "generic_save": "Save",
      "generic_edit": "Edit",
      "generic_delete": "Delete",
      "generic_invite": "Invite",
      "event_edit_title": "Edit Event",
      "event_form_name": "Event name",
      "event_form_date": "Select date",
      "event_form_date_empty": "Missing date",
      "event_form_date_past": "Past date",
      "event_form_time": "Select time (optional)",
      "event_form_venue": "Venue (optional)",
      "event_form_venue_helper": "Help your guests to find the venue",
      "event_form_purpose": "Enter event purpose (optional)",
      "event_form_purpose_helper": "Briefly describe the purpose of this event",
      "event_form_title": "Create Event",
      "event_host": "Host",
      "event_guest_count": "Guests ({count})",
      "event_details": "Event Details",
      "event_guests": "Guests",
      "event_leave": "Leave Event",
      "event_rsvp_yes_dialog": "You're going!",
      "event_rsvp_maybe_dialog": "You replied maybe",
      "event_rsvp_no_dialog": "You've declined!",
      "event_rsvp_yes": "Going",
      "event_rsvp_maybe": "Maybe",
      "event_rsvp_no": "Not Going",
      "event_rsvp_user": "Your response:",
      "event_rsvp_change": "Change",
      "event_private": "Private Event",
      "generic_create": "Create",
      "settings_title": "Settings",
      "topic_details": "Topic Details",
      "topic_members": "Members",
      "topic_leave": "Leave Topic",
      "topic_private": "Private Topic",
      "topic_members_count": "Members {count}",
      "platform_alert_access_title": "Please grant Timy access",
      "platform_alert_access_body": "For this feature to work the app need access to your {RESOURCE}",
      "platform_alert_access_resource_camera": "camera",
      "platform_alert_access_resource_photos": "photos",
      "privacy_button": "Privacy policy",
      "privacy_link": "https://www.iubenda.com/",
      "user_send_direct_message": "Send direct message",
      "user_edit_name_label": "Your name",
      "user_edit_name_helper": "Maximum 30 characters",
      "user_edit_name_error": "Name cannot be empty",
      "user_edit_status_label": "Your status",
      "user_edit_status_helper": "Maximum 200 characters",
      "user_deleted": "[deleted]",
    },
    "de": {
      "log_out": "Abmelden",
      "log_in": "Anmelden",
      "hello_name": "Hallo {name}!",
      "login_fail_user_not_found":
          "Login fehlgeschlagen. Wir konnten keinen Nutzer finden.",
      "login_fail": "Login fehlgeschlagen. Fehlercode: '{code}'",
      "calendar_title": "Kalender",
      "calendar_text_today": "Heute:",
      "calendar_text_all_day": "ganztägig",
      "channel_join": "Thema beitreten",
      "channel_join_message": "Tritt dem Thema bei um Nachrichten zu senden.",
      "channel_joined_postfix_message": "ist dem Thema beigetreten",
      "channel_joined_event_postfix_message": "ist dem Event beigetreten",
      "channel_left_postfix_message": "hat das Thema verlassen",
      "channel_left_event_postfix_message": "hat das Event verlassen",
      "channel_leave_alert_title": "Thema verlassen",
      "channel_leave_alert_message":
          "Möchtest du das Thema wirklich verlassen?",
      "channel_create_title": "Thema erstellen",
      "channel_create_button": "Erstellen",
      "channel_input_hint": "Nachricht",
      "channel_input_send": "Senden",
      "channel_title": "Themen",
      "channel_list_pending": "OFFEN",
      "channel_list_joined": "BEIGETRETEN",
      "channel_list_previous": "VERGANGEN",
      "channel_list_upcoming": "BEVORSTEHEND",
      "channel_list_events": "Events",
      "channel_list_unread": "Ungelesen",
      "channel_form_topic_name": "Thema",
      "channel_form_topic_description": "Beschreibung",
      "channel_form_topic_description_helper":
          "Beschreibe den Zweck des Themas",
      "channel_form_create_topic": "Thema erstellen",
      "channel_form_create_topic_empty_error": "Maximal 30 Zeichen",
      "channel_form_create_topic_exists_error": "Das Thema gibt es bereits.",
      "channel_form_create_topic_public": "Öffentlich",
      "channel_form_create_topic_private": "Privat",
      "channel_form_create_topic_public_helper":
          "Jeder in deiner Gruppe kann das Thema sehen",
      "channel_form_create_topic_private_helper": "Thema ist privat",
      "channel_form_topic_exists":
          "Es gibt bereits ein Thema mit diesem Namen.",
      "channel_form_select_members_error":
          "Bitte wähle mindestens ein Mitglied aus.",
      "channel_form_select_members": "Wähle Mitglieder für dein Thema aus:",
      "channel_invite_title": "Mitglieder einladen",
      "channel_invite_button": "Mitglieder hinzufügen",
      "channel_rsvp_yes_postfix": "nimmt teil",
      "channel_rsvp_no_postfix": "nimmt nicht teil",
      "channel_rsvp_maybe_postfix": "nimmt vielleicht teil",
      "attach_modal_title": "Bild anhängen",
      "attach_modal_subtitle": "Auswhählen von",
      "attach_modal_camera": "Kamera",
      "attach_modal_gallery": "Fotogalerie",
      "attach_error": "Fehler beim Anhängen des Bildes",
      "generic_soon_alert_title": "Wir arbeiten daran",
      "generic_soon_alert_message": "Diese Funktion wird bald verfügbar sein.",
      "generic_at": "at",
      "generic_back": "Zurück",
      "generic_cancel": "Abbrechen",
      "generic_delete": "Löschen",
      "generic_edit": "Bearbeiten",
      "generic_save": "Speichern",
      "generic_invite": "Einladen",
      "generic_next": "Weiter",
      "generic_ok": "OK",
      "generic_yes": "Ja",
      "generic_you": "Du",
      "event_edit_title": "Event bearbeiten",
      "event_form_name": "Eventname",
      "event_form_date": "Datum auswählen",
      "event_form_date_empty": "Fehlendes Datum",
      "event_form_date_past": "Vergangenes Datum",
      "event_form_time": "Zeit auswählen (optional)",
      "event_form_venue": "Ort (optional)",
      "event_form_venue_helper": "Helfe deinen Gästen den Ort zu finden",
      "event_form_purpose": "Eventbeschreibung (optional)",
      "event_form_purpose_helper": "Beschreibe den Zweck dieses Events",
      "event_form_title": "Event erstellen",
      "event_host": "Gastgeber",
      "event_guest_count": "Gäste ({count})",
      "event_details": "Eventdetails",
      "event_guests": "Gäste",
      "event_leave": "Event verlassen",
      "event_rsvp_yes_dialog": "Du hast zugesagt!",
      "event_rsvp_maybe_dialog": "Du gehst vielleicht hin!",
      "event_rsvp_no_dialog": "Du hast abgesagt!",
      "event_rsvp_yes": "Zusagen",
      "event_rsvp_maybe": "Vielleicht",
      "event_rsvp_no": "Absagen",
      "event_private": "Privates Event",
      "generic_create": "Erstellen",
      "settings_title": "Einstellungen",
      "topic_details": "Details",
      "topic_members": "Mitglieder",
      "topic_leave": "Thema verlassen",
      "topic_private": "Privates Thema",
      "topic_members_count": "Mitglieder {count}",
      "platform_alert_access_title": "Timy benötig Zugriff",
      "platform_alert_access_body": "Damit du diese Funktion nutzen kannst benötigen wir Zugriff auf deine {RESOURCE}",
      "platform_alert_access_resource_camera": "Kamera",
      "platform_alert_access_resource_photos": "Fotos",
      "privacy_button": "Datenschutzbestimmungen",
      "privacy_link": "https://www.iubenda.com/",
      "user_edit_name_label": "Dein Name",
      "user_edit_name_helper": "Maximal 30 Zeichen",
      "user_edit_name_error": "Name kann nicht leer sein",
      "user_edit_status_label": "Dein Status",
      "user_edit_status_helper": "Maximal 200 Zeichen",
      "user_send_direct_message": "Direktnachricht senden",
      "user_deleted": "[gelöscht]",
    },
    "pt_BR": {
      "log_out": "Sair",
      "log_in": "Log in",
      "hello_name": "Olá, {name}!",
      "login_fail_user_not_found": "Login falhou. O usuário não existe.",
      "login_fail": "Login falhou. Código: '{code}'",
      "calendar_title": "Calendário",
      "calendar_text_today": "Hoje:",
      "calendar_text_all_day": "dia inteiro",
      "channel_join": "Participar do canal",
      "channel_join_message": "Participe do canal para enviar mensagens.",
      "channel_joined_postfix_message": "entrou no canal",
      "channel_joined_event_postfix_message": "entrou no evento",
      "channel_left_postfix_message": "saiu do canal",
      "channel_left_event_postfix_message": "saiu do evento",
      "channel_leave_alert_title": "Sair do canal",
      "channel_leave_alert_message": "Você realmente deseja sair?",
      "channel_create_title": "Criar canal",
      "channel_create_button": "Criar",
      "channel_input_hint": "Mensagem",
      "channel_input_send": "Enviar",
      "channel_title": "Canais",
      "channel_list_pending": "PENDENTE",
      "channel_list_joined": "ENTROU",
      "channel_list_previous": "ANTERIOR",
      "channel_list_upcoming": "PRÓXIMOS",
      "channel_list_events": "Eventos",
      "channel_list_unread": "Não lido",
      "channel_form_topic_name": "Digite o nome do canal",
      "channel_form_topic_description": "Digite uma descrição (opcional)",
      "channel_form_topic_description_helper":
          "Descreva de forma sucinta a proposta do canal",
      "channel_form_create_topic": "Criar Canal",
      "channel_form_create_topic_empty_error": "Máximo de 30 caracteres",
      "channel_form_create_topic_exists_error": "Este canal já existe.",
      "channel_form_create_topic_public": "Aberto",
      "channel_form_create_topic_private": "Privado",
      "channel_form_create_topic_public_helper":
          "Todo mundo do grupo pode entrar",
      "channel_form_create_topic_private_helper":
          "Convide membros do grupo para este canal:",
      "channel_form_topic_exists":
          "Já existe um canal com este nome.",
      "channel_form_select_members_error": "Por favor, selecione ao menos um membro.",
      "channel_form_select_members":
          "Selecione quem pode participar deste canal:",
      "channel_invite_title": "Convide mais membros",
      "channel_invite_button": "Adicionar membros",
      "channel_rsvp_yes_postfix": "irá",
      "channel_rsvp_no_postfix": "não vai",
      "channel_rsvp_maybe_postfix": "talvez",
      "attach_modal_title": "Adicionar foto",
      "attach_modal_subtitle": "Selecionar de",
      "attach_modal_camera": "Câmera",
      "attach_modal_gallery": "Galeria",
      "attach_error": "Erro ao enviar foto",
      "generic_soon_alert_title": "Estamos trabalhando nisto",
      "generic_soon_alert_message":
          "Esta funcionalidade estará disponível em breve.",
      "generic_yes": "Sim",
      "generic_cancel": "Cancelar",
      "generic_next": "Próximo",
      "generic_ok": "OK",
      "generic_back": "Voltar",
      "generic_at": "em",
      "generic_you": "Você",
      "generic_save": "Salvar",
      "generic_edit": "Editar",
      "generic_delete": "Deletar",
      "generic_invite": "Convidar",
      "event_edit_title": "Editar Evento",
      "event_form_name": "Nome do Evento",
      "event_form_date": "Selecionar data",
      "event_form_date_empty": "Data é obrigatória",
      "event_form_date_past": "Data é anterior a hoje",
      "event_form_time": "Selecione a hora (optional)",
      "event_form_venue": "Local (optional)",
      "event_form_venue_helper": "Ajude seus convidados a encontrar o local",
      "event_form_purpose": "Digite uma descrição do evento (optional)",
      "event_form_purpose_helper": "De forma sucinta, diga a finalidade do evento",
      "event_form_title": "Criar Evento",
      "event_host": "Organizador",
      "event_guest_count": "Convidados ({count})",
      "event_details": "Detalhes do Evento",
      "event_guests": "Convidados",
      "event_leave": "Sair do Evento",
      "event_rsvp_yes_dialog": "Você confirmou presença!",
      "event_rsvp_maybe_dialog": "Você respondeu: talvez",
      "event_rsvp_no_dialog": "Você rejeitou!",
      "event_rsvp_yes": "Confirmados",
      "event_rsvp_maybe": "Talvez",
      "event_rsvp_no": "Não irão",
      "event_rsvp_user": "Sua resposta:",
      "event_rsvp_change": "Mudar",
      "event_private": "Evento Privado",
      "generic_create": "Criar",
      "settings_title": "Configurações",
      "topic_details": "Detalhes do tópico",
      "topic_members": "Membros",
      "topic_leave": "Sair do tópico",
      "topic_private": "Tópico privado",
      "topic_members_count": "Membros {count}",
      "platform_alert_access_title": "Por favor, libere a permissão do Timy",
      "platform_alert_access_body": "Para este recurso funcionar, o app precisa do acesso a {RESOURCE}",
      "platform_alert_access_resource_camera": "camera",
      "platform_alert_access_resource_photos": "fotos",
      "privacy_button": "Política de privacidade",
      "privacy_link": "https://www.iubenda.com/",
      "user_send_direct_message": "Enviar mensagem",
      "user_edit_name_label": "Sua mensagem",
      "user_edit_name_helper": "Máximo de 30 caracteres",
      "user_edit_name_error": "Nome não pode ser vazio",
      "user_edit_status_label": "Seu status",
      "user_edit_status_helper": "Máximo de 200 caracteres",
      "user_deleted": "[excluido]",
    }
  };

  /// This method returns the localized value of the passed id
  /// it defaults to english if the locale is missing
  String _localizedValue(String id) =>
      _localizedValues[locale.languageCode][id] ?? _localizedValues["en"][id];

  /// Calendar
  
  String get calendarTitle => _localizedValue("calendar_title");

  String get calendarStringToday => _localizedValue("calendar_text_today");

  String get calendarStringAllDay => _localizedValue("calendar_text_all_day");

  // Channel
  String get channelJoinMessage {
    return _localizedValue("channel_join_message");
  }

  String get channelLeaveAlertTitle {
    return _localizedValue("channel_leave_alert_title");
  }

  String get channelLeaveAlertMessage {
    return _localizedValue("channel_leave_alert_message");
  }

  String get channelJoin {
    return _localizedValue("channel_join");
  }

  String get channelCreateTitle {
    return _localizedValue("channel_create_title");
  }

  String get channelCreateButton {
    return _localizedValue("channel_create_button");
  }

  String get channelTitle {
    return _localizedValue("channel_title");
  }

  String get channelListPending {
    return _localizedValue("channel_list_pending");
  }

  String get channelListJoined {
    return _localizedValue("channel_list_joined");
  }

  String get channelListPrevious {
    return _localizedValue("channel_list_previous");
  }

  String get channelListUpcoming {
    return _localizedValue("channel_list_upcoming");
  }

  String get channelListEvents {
    return _localizedValue("channel_list_events");
  }

  String get channelListUnread {
    return _localizedValue("channel_list_unread");
  }

  String get channelFormTopicName {
    return _localizedValue("channel_form_topic_name");
  }

  String get channelFormTopicDescription {
    return _localizedValue("channel_form_topic_description");
  }

  String get channelFormTopicDescriptionHelper {
    return _localizedValue("channel_form_topic_description_helper");
  }

  String get channelFormCreateTopic {
    return _localizedValue("channel_form_create_topic");
  }

  String get channelFormCreateTopicEmptyError {
    return _localizedValue("channel_form_create_topic_empty_error");
  }

  String get channelFormCreateTopicExistsError {
    return _localizedValue("channel_form_create_topic_exists_error");
  }

  String get channelFormCreateTopicPrivate {
    return _localizedValue("channel_form_create_topic_private");
  }

  String get channelFormCreateTopicPublic {
    return _localizedValue("channel_form_create_topic_public");
  }

  String get channelFormCreateTopicPrivateHelper {
    return _localizedValue("channel_form_create_topic_private_helper");
  }

  String get channelFormCreateTopicPublicHelper {
    return _localizedValue("channel_form_create_topic_public_helper");
  }

  String get channelFormTopicExists {
    return _localizedValue("channel_form_topic_exists");
  }

  String get channelFormSelectMembersError {
    return _localizedValue("channel_form_select_members_error");
  }

  String get channelFormSelectMembers {
    return _localizedValue("channel_form_select_members");
  }

  String get channelInputHint {
    return _localizedValue("channel_input_hint");
  }

  String get channelInputSend {
    return _localizedValue("channel_input_send");
  }

  String get channelInviteTitle =>
      _localizedValues[locale.languageCode]["channel_invite_title"];

  String get invite => _localizedValues[locale.languageCode]["generic_invite"];

  get channelInviteButton =>
      _localizedValues[locale.languageCode]["channel_invite_button"];

  // Generic
  String get genericSoonAlertTitle {
    return _localizedValue("generic_soon_alert_title");
  }

  String get genericSoonAlertMessage {
    return _localizedValue("generic_soon_alert_message");
  }

  String get yes {
    return _localizedValue("generic_yes");
  }

  String get cancel {
    return _localizedValue("generic_cancel");
  }

  String get next {
    return _localizedValue("generic_next");
  }

  String get ok {
    return _localizedValue("generic_ok");
  }

  String get back {
    return _localizedValue("generic_back");
  }

  String get at => _localizedValue("generic_at");

  String get you => _localizedValue("generic_you");

  String get save => _localizedValue("generic_save");

  String get edit => _localizedValue("generic_edit");

  String get delete => _localizedValue("generic_delete");

  String get sendDirectMessage => _localizedValue("user_send_direct_message");

  String get userEditNameLabel => _localizedValue("user_edit_name_label");

  String get userEditNameHelper => _localizedValue("user_edit_name_helper");

  String get userEditNameError => _localizedValue("user_edit_name_error");

  String get userEditStatusLabel => _localizedValue("user_edit_status_label");

  String get userEditStatusHelper => _localizedValue("user_edit_status_helper");

  String get deletedUser => _localizedValue("user_deleted");

  // Auth
  String get logIn {
    return _localizedValue("log_in");
  }

  String get logOut {
    return _localizedValue("log_out");
  }

  String hello(String name) {
    return _localizedValue("hello_name").replaceAll("{name}", name);
  }

  String authErrorMessage(String code) {
    switch (code) {
      case "ERROR_USER_NOT_FOUND":
        return _localizedValue("login_fail_user_not_found");
      default:
        return _localizedValue("login_fail").replaceAll("{code}", code);
    }
  }

  String get attachModalTitle => _localizedValue("attach_modal_title");

  String get attachModalSubtitle => _localizedValue("attach_modal_subtitle");

  String get attachModalCamera => _localizedValue("attach_modal_camera");

  String get attachModalGallery => _localizedValue("attach_modal_gallery");

  String get attachError => _localizedValue("attach_error");

  String get eventEditTitle => _localizedValue("event_edit_title");

  String get eventFormName => _localizedValue("event_form_name");

  String get eventFormDate => _localizedValue("event_form_date");

  String get eventFormDateEmpty => _localizedValue("event_form_date_empty");

  String get eventFormDatePast => _localizedValue("event_form_date_past");

  String get eventFormTime => _localizedValue("event_form_time");

  String get eventFormVenue => _localizedValue("event_form_venue");

  String get eventFormVenueHelper => _localizedValue("event_form_venue_helper");

  String get eventFormPurpose => _localizedValue("event_form_purpose");

  String get eventFormPurposeHelper =>
      _localizedValue("event_form_purpose_helper");

  String get eventCreateTitle => _localizedValue("event_form_title");

  String eventGuestCount(String count) {
    return _localizedValue("event_guest_count").replaceAll("{count}", count);
  }

  String rsvpSystemMessage(String rsvpMessage) {
    return rsvpMessage
        .replaceAll("{RSVP_YES}", _channelRSVPYesPostfix)
        .replaceAll("{RSVP_MAYBE}", _channelRSVPMaybePostfix)
        .replaceAll("{RSVP_NO}", _channelRSVPNoPostfix);
  }

  String get _channelRSVPYesPostfix =>
      _localizedValue("channel_rsvp_yes_postfix");

  String get _channelRSVPNoPostfix =>
      _localizedValue("channel_rsvp_no_postfix");

  String get _channelRSVPMaybePostfix =>
      _localizedValue("channel_rsvp_maybe_postfix");

  String channelSystemMessage(String joinedChannelMessage) {
    return joinedChannelMessage
        .replaceAll("{JOINED_CHANNEL}", _joinChannelPostfix)
        .replaceAll("{JOINED_EVENT}", _joinEventPostfix)
        .replaceAll("{LEFT_EVENT}", _leftEventPostfix)
        .replaceAll("{LEFT_CHANNEL}", _leftChannelPostfix);
  }

  String get _joinChannelPostfix =>
      _localizedValue("channel_joined_postfix_message");

  String get _joinEventPostfix =>
      _localizedValue("channel_joined_event_postfix_message");

  String get _leftChannelPostfix =>
      _localizedValue("channel_left_postfix_message");

  String get _leftEventPostfix =>
      _localizedValue("channel_left_event_postfix_message");

  String get eventHost => _localizedValue("event_host");

  String get eventDetails => _localizedValue("event_details");

  String get eventGuests => _localizedValue("event_guests");

  String get eventLeave => _localizedValue("event_leave");

  String get eventRsvpDialogYes => _localizedValue("event_rsvp_yes_dialog");

  String get eventRsvpDialogMaybe => _localizedValue("event_rsvp_maybe_dialog");

  String get eventRsvpDialogNo => _localizedValue("event_rsvp_no_dialog");

  get eventRsvpYes => _localizedValue("event_rsvp_yes");

  get eventRsvpMaybe => _localizedValue("event_rsvp_maybe");

  get eventRsvpNo => _localizedValue("event_rsvp_no");

  get eventRsvpUser => _localizedValue("event_rsvp_user");

  get eventRsvpChange => _localizedValue("event_rsvp_change");

  get eventPrivate => _localizedValue("event_private");

  String get create => _localizedValue("generic_create");

  String get privacyButton => _localizedValue("privacy_button");

  String get privacyLink => _localizedValue("privacy_link");

  get settingsTitle => _localizedValue("settings_title");

  String get topicDetails {
    return _localizedValue("topic_details");
  }

  String get topicMembers {
    return _localizedValue("topic_members");
  }

  String get topicLeave {
    return _localizedValue("topic_leave");
  }

  String get topicPrivate {
    return _localizedValue("topic_private");
  }

  String topicMembersCount(String count) {
    return _localizedValue("topic_members_count").replaceAll("{count}", count);
  }

  /// Platform 
  String get platformAlertAccessTitle => _localizedValue("platform_alert_access_title");

  String platformAlertAccessBody(AccessResourceType type) {
    final typeString = type == AccessResourceType.CAMERA ? platformAlertAccessResourceCamera : platformAlertAccessResourcePhotos;
    return _localizedValue("platform_alert_access_body").replaceAll("{RESOURCE}", typeString);
  }

  String get platformAlertAccessResourceCamera => _localizedValue("platform_alert_access_resource_camera");
  String get platformAlertAccessResourcePhotos => _localizedValue("platform_alert_access_resource_photos");
}

class CirclesLocalizationsDelegate
    extends LocalizationsDelegate<CirclesLocalizations> {
  const CirclesLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ["en", "de", "pt_BR"].contains(locale.languageCode);

  @override
  Future<CirclesLocalizations> load(Locale locale) {
    return SynchronousFuture<CirclesLocalizations>(
        CirclesLocalizations(locale));
  }

  @override
  bool shouldReload(CirclesLocalizationsDelegate old) => false;
}
