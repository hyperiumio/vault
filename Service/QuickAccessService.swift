actor QuickAccessService: QuickAccessDependency {
    
}

#if DEBUG
actor QuickAccessServiceStub {}

extension QuickAccessServiceStub: QuickAccessDependency {}
#endif
