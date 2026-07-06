/// Request model for submitting a new question to the community.
class CreateQuestionRequest {
  final String title;
  final String body;
  final String? tag;

  CreateQuestionRequest({
    required this.title,
    required this.body,
    this.tag,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        if (tag != null) 'tag': tag,
      };

  factory CreateQuestionRequest.fromJson(Map<String, dynamic> json) =>
      CreateQuestionRequest(
        title: json['title'] as String,
        body: json['body'] as String,
        tag: json['tag'] as String?,
      );
}

/// Request model for submitting an answer to a question.
class CreateAnswerRequest {
  final String questionId;
  final String body;

  CreateAnswerRequest({
    required this.questionId,
    required this.body,
  });

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'body': body,
      };

  factory CreateAnswerRequest.fromJson(Map<String, dynamic> json) =>
      CreateAnswerRequest(
        questionId: json['question_id'] as String,
        body: json['body'] as String,
      );
}

/// Request model for submitting a project.
class CreateProjectRequest {
  final String title;
  final String summary;
  final String? description;
  final List<String>? techStack;
  final String? githubUrl;
  final String? liveUrl;

  CreateProjectRequest({
    required this.title,
    required this.summary,
    this.description,
    this.techStack,
    this.githubUrl,
    this.liveUrl,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'summary': summary,
        if (description != null) 'description': description,
        if (githubUrl != null) 'github_url': githubUrl,
        if (liveUrl != null) 'live_url': liveUrl,
      };

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) =>
      CreateProjectRequest(
        title: json['title'] as String,
        summary: json['summary'] as String,
        description: json['description'] as String?,
        githubUrl: json['github_url'] as String?,
        liveUrl: json['live_url'] as String?,
      );
}
