import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_batch_plan.dart';

part 'plan_state.dart';

class CoursePlanCubit extends Cubit<CoursePlanState> {
  CoursePlanCubit() : super(CoursePlanInitial());
  String? planId;
  int? planValidity;
  List<GetBatchPlanData> plans = [];

  void selectPlan({required String planId, required int planValidity}) {
    emit(CoursePlanInitial());
    this.planId = planId;
    this.planValidity = planValidity;
    emit(CoursePlanSelected());
  }

  Future<void> getPlan({required String id}) async {
    emit(CoursePlanInitial());
    GetBatchPlan res = await RemoteDataSourceImpl().getBatchPlan(id: id);
    if ((res.status ?? false) && (res.data?.isNotEmpty ?? false)) {
      plans = res.data ?? [];
      planId = res.data?.firstWhere((x) => x.isRecommended == true, orElse: () => res.data!.first).validityId;
      planValidity = res.data?.firstWhere((x) => x.isRecommended == true, orElse: () => res.data!.first).month;
    }
    emit(CoursePlanSelected());
  }
}
