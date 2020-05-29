@testset "test state estimators" begin

    @testset "case3_unbalanced" begin

        meas_case3 = "test/data/case3_input.csv"
        data_case3 = _PMD.parse_file("test/data/opendss/case3_unbalanced.dss")
        pmd_data_case3 = _PMD.transform_data_model(data_case3)
        PowerModelsDSSE.add_measurement_to_pmd_data!(pmd_data_case3, meas_file; actual_meas=false, seed=0)
        PowerModelsDSSE.add_measurement_id_to_load!(pmd_data_case3, meas_case3)

        @testset "simple acp case3 wlav se" begin
            pmd_data_case3["setting"] = Dict{String, Any}("estimation_criterion" => "wlav")
            se_res_case3 = PowerModelsDSSE.run_acp_mc_se(pmd_data_case3, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            pf_res_case3 = _PMD.run_mc_pf(pmd_data_case3, _PMs.ACPPowerModel, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            vm_err_array_case3,err_max_case3,err_mean_case3 = PowerModelsDSSE.calculate_error(se_res_case3, pf_res_case3; vm_or_va = "vm")
            @test se_res_case3["termination_status"] == LOCALLY_SOLVED
            @test isapprox(se_res_case3["objective"], 12060.6; atol=1e-1)
            @test isapprox(err_max_case3, 0.00124770005; atol=1e-8)
            @test isapprox(err_mean_case3, 0.0009345758831; atol=1e-8)
        end

        @testset "simple acp case3 wls se" begin
            pmd_data_case3["setting"] = Dict("estimation_criterion" => "wls",
                                        "weight_rescaler" => 1000000)
            se_res_case3 = PowerModelsDSSE.run_acp_mc_se(pmd_data_case3, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            pf_res_case3 = _PMD.run_mc_pf(pmd_data_case3, _PMs.ACPPowerModel, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            vm_err_array_case3,err_max_case3,err_mean_case3 = PowerModelsDSSE.calculate_error(se_res_case3, pf_res_case3; vm_or_va = "vm")
            @test se_res_case3["termination_status"] == LOCALLY_SOLVED
            @test isapprox(se_res_case3["objective"], 2.4426e-5; atol=1e-8)
            @test isapprox(err_max_case3, 0.001351283709; atol=1e-8)
            @test isapprox(err_mean_case3, 0.000974577035348; atol=1e-8)
        end

        @testset "simple ivr case3 wlav se" begin
            pmd_data_case3["setting"] = Dict{String, Any}("estimation_criterion" => "wlav")
            se_res_case3 = PowerModelsDSSE.run_ivr_mc_se(pmd_data_case3, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            pf_res_case3 = _PMD.run_mc_pf(pmd_data_case3, _PMs.IVRPowerModel, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            vm_err_array_case3,err_max_case3,err_mean_case3 = PowerModelsDSSE.calculate_error(se_res_case3, pf_res_case3; vm_or_va = "vm")
            @test se_res_case3["termination_status"] == LOCALLY_SOLVED
            @test isapprox(se_res_case3["objective"], 13466.2; atol=1e-1)
            @test isapprox(err_max_case3, 0.00124806636; atol=1e-8)
            @test isapprox(err_mean_case3, 0.00093484049; atol=1e-8)
        end

        @testset "simple ivr case3 wls se" begin
            pmd_data_case3["setting"] = Dict("estimation_criterion" => "wls",
                                                "weight_rescaler" => 1000000)
            se_res_case3 = PowerModelsDSSE.run_ivr_mc_se(pmd_data_case3, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            pf_res_case3 = _PMD.run_mc_pf(pmd_data_case3, _PMs.IVRPowerModel, optimizer_with_attributes(Ipopt.Optimizer, "tol"=>1e-6, "print_level"=>0))
            vm_err_array_case3,err_max_case3,err_mean_case3 = PowerModelsDSSE.calculate_error(se_res_case3, pf_res_case3; vm_or_va = "vm")
            @test se_res_case3["termination_status"] == LOCALLY_SOLVED
            @test isapprox(se_res_case3["objective"], 2.53036e-5; atol=1e-8)
            @test isapprox(err_max_case3, 0.001274638413; atol=1e-8)
            @test isapprox(err_mean_case3,0.000962681849; atol=1e-8)
        end
    end#case3_unabalanced
end#@testset