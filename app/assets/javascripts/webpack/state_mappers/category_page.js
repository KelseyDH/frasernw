import TableHeadingGenerators from "state_mappers/filter_table/table_headings_generators";
import { from } from "utils";
import RowGenerators from "state_mappers/filter_table/row_generators";
import itemsForCategory from "domain/content_category_items";
import SortFunctions from "state_mappers/filter_table/sort_functions";
import SortOrders from "state_mappers/filter_table/sort_orders";
import Filters from "state_mappers/filter_table/filters"

export default function(state, dispatch) {
  console.log(state);

  if(state.ui.hasBeenInitialized) {
    const _divisionIds = divisionIds(state);
    const _maskingSet =
      itemsForCategory(state.ui.contentCategoryId, state, _divisionIds);
    const _sortConfig = sortConfig(state);
    const _filterValues =
      _.mapValues(FilterValues, (value) => value(state, _maskingSet));

    return {
      bodyRows: bodyRows(state, dispatch, _sortConfig, _maskingSet, _filterValues),
      resultSummary: { isVisible: false },
      cityFilterPills: { shouldDisplay: false },
      specializationFilterMessage: { shouldDisplay: false },
      assumedList: { shouldDisplay: false },
      reducedView: _.get(state, ["ui", "reducedView"], "main"),
      sortConfig: _sortConfig,
      headings: TableHeadingGenerators.contentCategories(),
      // TODO name this 'sidebarFilteringSection'
      filters: {
        title: `Filter ${state.app.contentCategories[state.ui.contentCategoryId].name}`,
        // TODO: name this 'sidebarFilteringSectionGroups'
        groups: _.map(FilterGroups, (group) => group(state, _filterValues)),
      },
      dispatch: dispatch
    }
  }
  else {
    return { isLoading: true };
  }
};

const operativeFilterKeys = ["subcategories", "specialties"];
const bodyRows = (state, dispatch, sortConfig, maskingSet, filterValues) => {
  const _operativeFilters = _.values(_.pick(Filters, operativeFilterKeys))
    .filter((filter) => filter.isActivated(filterValues))
    .map(_.property("predicate"));

  return from(
    _.partialRight(_.sortByOrder, SortFunctions.contentCategories(sortConfig), SortOrders.contentCategories(sortConfig)),
    _.partialRight(_.map, _.partial(RowGenerators.resources, state.app, dispatch, { panelKey: 0 })),
    _.partialRight(_.filter, (record) => _.every(_operativeFilters, (filter) => filter(record, filterValues))),
    maskingSet
  );
};

const divisionIds = (state) => {
  if(state.app.currentUser.isSuperAdmin) {
    return _.values(state.app.divisions).map(_.property("id"));
  }
  else {
    return state.app.currentUser.divisionIds;
  }
}

const sortConfig = (state) => ({
  order: _.get(state, ["ui", "sortConfig", "order"], "DOWN"),
  column: _.get(state, ["ui", "sortConfig", "column"], "TITLE"),
})

const FilterValues = {
  subcategories: function(state, maskingSet) {
    return _.chain(maskingSet)
     .map((record) => record.categoryId)
     .flatten()
     .uniq()
     .without(state.ui.contentCategoryId)
     .reduce((memo, id) => {
       return _.assign(
         { [id]: _.get(state, ["ui", "filterValues", "subcategories", id], false) },
         memo
       );
     }, {})
     .value();
  },
}

const FilterGroups = {
  subcategories: function(state: Object, filterValues: Object): Object {
    return {
      filters: {
        subcategories: _.map(
          filterValues.subcategories,
          function(value: boolean, subcategoryId: string) {
            return {
              filterId: subcategoryId,
              label: state.app.contentCategories[subcategoryId].name,
              value: value
            };
          }
        ),
      },
      title: "Subcategories",
      isOpen: _.get(state, ["ui" ,"filterGroupVisibility", "subcategories"], true),
      shouldDisplay: _.any(_.keys(filterValues.subcategories)),
      componentKey: "subcategories",
    };
  },
}
